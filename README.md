```markdown
# MyWeatherApp

## Description
MyWeatherApp is a serverless application designed to provide real-time weather information. It's built on AWS Lambda, demonstrating a cloud-native approach to software development.

## Features
- Fetch current weather data for any city.
- Serverless architecture leveraging AWS Lambda.
- Integration with OpenWeather API for weather data.

## Prerequisites
- AWS account with access to Lambda, API Gateway, and S3 services.
- Node.js and npm installed.
- Serverless Framework for deployment.

## Installation & Setup
1. Clone the repository:
   ```
   git clone https://github.com/GershonRocks/MyWeatherApp.git
   ```
2. Navigate to the project directory and install dependencies:
   ```
   cd MyWeatherApp
   npm install
   ```

## Configuration
- Set up AWS credentials for Serverless deployment.
- Configure environment variables for OpenWeather API key (`OPENWEATHER_API_KEY`).

## Deployment
Deploy the application using Serverless Framework:
```
serverless deploy
```

## Usage
After deployment, the application can be accessed through the generated API Gateway endpoint:
```
https://{api_gateway_id}.execute-api.{region}.amazonaws.com/weather?city={city_name}
```

## Contributing
Contributions to the project are welcome. Please fork the repository and submit a pull request with your changes.

## License
This project is licensed under the [MIT License](LICENSE).

## Author
- Gershon Avital - shraga@tgx-group.com
```

