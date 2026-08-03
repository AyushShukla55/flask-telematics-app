CREATE TABLE IF NOT EXISTS vehicle_telemetry (
    id SERIAL PRIMARY KEY,
    vehicle_id VARCHAR(50) NOT NULL,
    speed DOUBLE PRECISION NOT NULL,
    fuel_level DOUBLE PRECISION NOT NULL,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

TRUNCATE TABLE vehicle_telemetry RESTART IDENTITY;

INSERT INTO vehicle_telemetry (vehicle_id, speed, fuel_level, status) VALUES
    ('TRUCK-101', 65.5, 82.0, 'ACTIVE'),
    ('TRUCK-102', 88.4, 45.0, 'SPEEDING'),
    ('VAN-201', 0.0, 95.0, 'IDLE'),
    ('VAN-202', 72.0, 15.5, 'LOW_FUEL'),
    ('BUS-301', 92.1, 62.0, 'SPEEDING'),
    ('BUS-302', 45.0, 78.5, 'ACTIVE'),
    ('CAR-401', 58.0, 12.0, 'LOW_FUEL'),
    ('CAR-402', 0.0, 88.0, 'IDLE');