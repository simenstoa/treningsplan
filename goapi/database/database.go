package database

import (
	"context"
	"database/sql"
	"fmt"
	"github.com/golang-migrate/migrate/v4"
	"github.com/golang-migrate/migrate/v4/database/postgres"
	_ "github.com/golang-migrate/migrate/v4/source/file"
	_ "github.com/lib/pq"
	"goapi/config"
	"goapi/logger"
	"sort"
)

type Client interface {
	Close() error
	GetIntensities(ctx context.Context) ([]Intensity, error)
	GetWorkouts(ctx context.Context) ([]Workout, error)
}

type client struct {
	db *sql.DB
}

func NewClient(ctx context.Context, cfg config.Config) (Client, error) {
	log := logger.FromContext(ctx)

	log.Info("Connecting to db")
	psqlInfo := fmt.Sprintf("host=%s port=%d user=%s password=%s dbname=%s sslmode=disable",
		cfg.PostgresHost, cfg.PostgresPort, cfg.PostgresUser, cfg.PostgresPassword, cfg.PostgresName)

	db, err := sql.Open("postgres", psqlInfo)
	if err != nil {
		log.WithError(err).Error("Error while opening db connection")
		return nil, err
	}

	log.Info("Testing db connection")
	err = db.PingContext(ctx)
	if err != nil {
		log.WithError(err).Error("Error while testing db connection")
		return nil, err
	}

	log.Info("Running database migrations")
	driver, err := postgres.WithInstance(db, &postgres.Config{})
	m, err := migrate.NewWithDatabaseInstance(
		"file://database/migrations",
		cfg.PostgresName, driver)
	if err != nil {
		log.WithError(err).Error("Could not init migration")
		return nil, err
	}
	err = m.Up()
	if err != nil {
		if err != migrate.ErrNoChange {
			log.WithError(err).Error("Error during migration")
			return nil, err
		}
	}

	return &client{
		db: db,
	}, nil
}

func (c *client) Close() error {
	return c.db.Close()
}

func (c *client) GetIntensities(ctx context.Context) ([]Intensity, error) {
	log := logger.FromContext(ctx)

	sqlStatement := `SELECT intensity_uid, name, description, coefficient FROM Intensity;`

	rows, err := c.db.Query(sqlStatement)
	if err != nil {
		log.WithError(err).Error("Error querying db")
		return []Intensity{}, err
	}
	defer func() {
		err := rows.Close()
		log.WithError(err).Error("Error closing db query connection")
	}()

	var intensities []Intensity
	for rows.Next() {
		var intensity Intensity
		err = rows.Scan(&intensity.Id, &intensity.Name, &intensity.Description, &intensity.Coefficient)
		if err != nil {
			log.WithError(err).Error("Error while parsing db row")
			return []Intensity{}, err
		}
		intensities = append(intensities, intensity)
	}
	// get any error encountered during iteration
	err = rows.Err()
	if err != nil {
		log.WithError(err).Error("Error while parsing db rows")
		return []Intensity{}, err
	}

	return intensities, nil
}

func (c *client) GetWorkouts(ctx context.Context) ([]Workout, error) {
	log := logger.FromContext(ctx)

	sqlStatement :=
		`SELECT 
       			w.workout_uid, w.name, w.description,
       			wp."order", wp.distance, wp.metric,
       			i.intensity_uid, i.name, i.description, i.coefficient 
				FROM workout AS w 
			    JOIN workout_parts AS wp USING(workout_uid) 
			    JOIN Intensity as I USING(intensity_uid);`

	rows, err := c.db.Query(sqlStatement)
	if err != nil {
		log.WithError(err).Error("Error querying db")
		return []Workout{}, err
	}
	defer func() {
		err := rows.Close()
		log.WithError(err).Error("Error closing db query connection")
	}()

	workouts := make(map[string]Workout)
	for rows.Next() {
		var workout Workout
		var part WorkoutPart
		var intensity Intensity
		err = rows.Scan(
			&workout.Id, &workout.Name, &workout.Description,
			&part.Order, &part.Distance, &part.Metric,
			&intensity.Id, &intensity.Name, &intensity.Description, &intensity.Coefficient,
		)
		if err != nil {
			log.WithError(err).Error("Error while parsing db row")
			return []Workout{}, err
		}

		part.Intensity = intensity
		if existingWorkout, ok := workouts[workout.Id]; ok {
			existingWorkout.Parts = append(existingWorkout.Parts, part)
		} else {
			workout.Parts = append(workout.Parts, part)
			workouts[workout.Id] = workout
		}
	}
	// get any error encountered during iteration
	err = rows.Err()
	if err != nil {
		log.WithError(err).Error("Error while parsing db rows")
		return []Workout{}, err
	}

	var workoutList []Workout
	for _, workout := range workouts {
		sort.Slice(workout.Parts, func(i, j int) bool {
			return workout.Parts[i].Order < workout.Parts[j].Order
		})
		workoutList = append(workoutList, workout)
	}

	return workoutList, nil
}
