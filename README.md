(Sample)

### Service Contract Testing for a Product Details Web API

Uses Bash, Node, and R to make a series of requests and deliver a report containing quality of service and message structure validation.

#### Setup Routines

Uses bash script to parse CSV data and cURL requests. Connection statistics and message bodies are saved for analysis.

#### Validation

Uses `jasmine-node` to do contract testing (similar to [frisbeeJS](http://frisbyjs.com/) on the JSON returned.

#### QoS

Parses the cURL connection stats to generate a digest for "at-a-glance" results, and uses R to generate pretty pictures:

<img style="width: 80%;" src="https://dl.dropboxusercontent.com/u/31581852/API-QoS-sample.jpeg">
<img style="width: 50%;" src="https://dl.dropboxusercontent.com/u/31581852/API-QoS-qos.jpg">
