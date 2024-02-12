from flask import Flask, render_template, request
import requests
import os

app = Flask(__name__)

# Configuration
API_KEY = os.getenv('API_KEY', '809c3f1062f16fb589ed80c2c331d287')
API_URL = 'https://api.openweathermap.org/data/2.5/weather'

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/weather', methods=['GET', 'POST'])
def weather():
    if request.method == 'POST':
        city = request.form['city']
        units = request.form['units']
        params = {
            'q': city,
            'units': units,
            'appid': API_KEY
        }
        response = requests.get(API_URL, params=params)
        weather_data = response.json()
        return render_template('weather.html', weather_data=weather_data)
    return render_template('weather.html')

if __name__ == '__main__':
    app.run(debug=True)
