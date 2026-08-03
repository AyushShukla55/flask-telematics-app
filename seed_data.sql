import os
import time
from datetime import datetime, timezone
from flask import Flask, request, jsonify, render_template
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.exc import OperationalError
from sqlalchemy import func

app = Flask(__name__)

# Database Configuration (reads strictly from environment variables)
DB_USER = os.environ.get('POSTGRES_USER', 'postgres')
DB_PASSWORD = os.environ.get('POSTGRES_PASSWORD', '')
DB_HOST = os.environ.get('POSTGRES_HOST', 'localhost')
DB_PORT = os.environ.get('POSTGRES_PORT', '5432')
DB_NAME = os.environ.get('POSTGRES_DB', 'telematics_db')

app.config['SQLALCHEMY_DATABASE_URI'] = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

# Database Model
class VehicleLog(db.Model):
    __tablename__ = 'vehicle_telemetry'
    id = db.Column(db.Integer, primary_key=True)
    vehicle_id = db.Column(db.String(50), nullable=False)
    speed = db.Column(db.Float, nullable=False)
    fuel_level = db.Column(db.Float, nullable=False)
    status = db.Column(db.String(20), default='ACTIVE')
    timestamp = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc))

    def to_dict(self):
        return {
            'id': self.id,
            'vehicle_id': self.vehicle_id,
            'speed_kmph': self.speed,
            'fuel_percentage': self.fuel_level,
            'status': self.status,
            'timestamp': self.timestamp.strftime('%Y-%m-%d %H:%M:%S') if self.timestamp else None
        }

# Database Initialization with Retry Loop
def init_db():
    with app.app_context():
        retries = 10
        while retries > 0:
            try:
                db.create_all()
                print("Database initialized successfully!")
                break
            except OperationalError:
                retries -= 1
                print(f"Database connecting... retrying ({retries} left)")
                time.sleep(3)

# Frontend Dashboard Route
@app.route('/')
def index():
    logs = VehicleLog.query.order_by(VehicleLog.timestamp.desc()).all()
    total_vehicles = db.session.query(func.count(func.distinct(VehicleLog.vehicle_id))).scalar() or 0
    avg_speed = db.session.query(func.avg(VehicleLog.speed)).scalar() or 0.0
    avg_fuel = db.session.query(func.avg(VehicleLog.fuel_level)).scalar() or 0.0
    speeding_count = VehicleLog.query.filter_by(status='SPEEDING').count()
    low_fuel_count = VehicleLog.query.filter_by(status='LOW_FUEL').count()

    summary = {
        "active_vehicles": total_vehicles,
        "average_speed": round(avg_speed, 1),
        "average_fuel": round(avg_fuel, 1),
        "speeding_alerts": speeding_count,
        "low_fuel_alerts": low_fuel_count
    }
    return render_template('index.html', logs=logs, summary=summary)

# API Endpoint: GET all telemetry logs
@app.route('/api/telemetry', methods=['GET'])
def get_telemetry():
    logs = VehicleLog.query.order_by(VehicleLog.timestamp.desc()).all()
    return jsonify([log.to_dict() for log in logs])

# API Endpoint: POST new telemetry log (Auto-calculates vehicle status)
@app.route('/api/telemetry', methods=['POST'])
def add_telemetry():
    data = request.get_json() or {}
    vehicle_id = data.get('vehicle_id')
    speed = data.get('speed')
    fuel_level = data.get('fuel_level')

    if not vehicle_id or speed is None or fuel_level is None:
        return jsonify({'error': 'Missing required fields: vehicle_id, speed, fuel_level'}), 400

    try:
        speed_val = float(speed)
        fuel_val = float(fuel_level)
    except (ValueError, TypeError):
        return jsonify({'error': 'Speed and fuel_level must be valid numbers'}), 400

    # Dynamic status calculation
    status = "ACTIVE"
    if speed_val > 80.0:
        status = "SPEEDING"
    elif fuel_val < 20.0:
        status = "LOW_FUEL"
    elif speed_val == 0.0:
        status = "IDLE"

    new_log = VehicleLog(
        vehicle_id=str(vehicle_id).strip(),
        speed=speed_val,
        fuel_level=fuel_val,
        status=status
    )
    db.session.add(new_log)
    db.session.commit()

    return jsonify({'message': 'Telemetry ingested successfully', 'data': new_log.to_dict()}), 201

# API Endpoint: GET fleet analytics summary
@app.route('/api/analytics', methods=['GET'])
def get_analytics():
    total_vehicles = db.session.query(func.count(func.distinct(VehicleLog.vehicle_id))).scalar() or 0
    avg_speed = db.session.query(func.avg(VehicleLog.speed)).scalar() or 0.0
    avg_fuel = db.session.query(func.avg(VehicleLog.fuel_level)).scalar() or 0.0
    speeding_count = VehicleLog.query.filter_by(status='SPEEDING').count()
    low_fuel_count = VehicleLog.query.filter_by(status='LOW_FUEL').count()

    return jsonify({
        "fleet_summary": {
            "active_vehicles": total_vehicles,
            "average_speed_kmph": round(avg_speed, 2),
            "average_fuel_level_percentage": round(avg_fuel, 2)
        },
        "alerts": {
            "speeding_violations": speeding_count,
            "low_fuel_warnings": low_fuel_count
        }
    })

if __name__ == '__main__':
    init_db()
    app.run(host='0.0.0.0', port=5000, debug=True)
