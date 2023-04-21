import subprocess
import json
import argparse
import re
import os

# Create an ArgumentParser object
parser = argparse.ArgumentParser(description='Convert .xcresult to JSON and generate code coverage report.')

# Add a positional argument for the .xcresult file path
parser.add_argument('xcresult_path', type=str, help='Path to the .xcresult file')

# Parse the command-line arguments
args = parser.parse_args()

# Access the value of the .xcresult file path argument
xcresult_path = args.xcresult_path

# Run xcresulttool command to convert .xcresult to JSON
result = subprocess.run(['xcrun', 'xcresulttool', 'get', '--format', 'json', '--path', xcresult_path], capture_output=True, text=True)

# Check for any errors
if result.returncode != 0:
    print("Error converting .xcresult to JSON:", result.stderr)
else:
    # Load the JSON data
    data = json.loads(result.stdout)

    # Access and process the JSON data as needed
    type_name = data["_type"]["_name"]
    actions_type_name = data["actions"]["_type"]["_name"]
    action_result_type_name = data["actions"]["_values"][0]["actionResult"]["_type"]["_name"]
    result_name = data["actions"]["_values"][0]["actionResult"]["resultName"]["_value"]
    status_value = data["actions"]["_values"][0]["actionResult"]["status"]["_value"]
    metrics_tests_count_value = data["actions"]["_values"][0]["actionResult"]["metrics"]["testsCount"]["_value"]

    # Print the extracted values
    print("Type name: ", type_name)
    print("Actions type name: ", actions_type_name)
    print("Action result type name: ", action_result_type_name)
    print("Result name: ", result_name)
    print("Status value: ", status_value)
    print("Metrics tests count value: ", metrics_tests_count_value)

    # Run xccov command to generate code coverage report
    xccov_result = subprocess.run(['xcrun', 'xccov', 'view', '--report', xcresult_path], capture_output=True, text=True)

    # Check for any errors
    if xccov_result.returncode != 0:
        print("Error generating code coverage report:", xccov_result.stderr)
    else:
        # Extract file paths and code coverage information using regular expressions
        coverage_pattern = r'(?P<path>.*?(\.swift|\.app))\s+(?P<coverage>\d+\.\d+% \(\d+/\d+\))'
        matches = re.findall(coverage_pattern, xccov_result.stdout)
        coverage_data = []

        # Print the extracted file paths and code coverage information
        print("\nCode Coverage Report:")
        for match in matches:
            file_path = match[0]
            coverage = match[2]
            file_name = os.path.basename(file_path)

            coverage_data.append({
                'File': file_name,
                'Coverage': coverage
            })
            # print("File: {}".format(file_name))
            # print("Coverage: {}".format(coverage))
            # print("------------------")

        # Convert the coverage data to JSON format
        coverage_json = json.dumps(coverage_data, indent=4)
        print(coverage_json)
