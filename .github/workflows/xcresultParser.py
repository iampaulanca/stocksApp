import subprocess
import json
import argparse
import re
import os
import datetime


class CodeCoverage:
    def __init__(self, appName, id, filenames, totalCoverage):
        self.appName = appName
        self.id = id
        self.filenames = filenames
        self.totalCoverage = totalCoverage
        self.timestamp = datetime.datetime.now()


class Filename:
    def __init__(self, name, coverage):
        self.name = name
        self.coverage = coverage


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
        # Create Filename objects for each file with its name and coverage
        filenames = []
        # Create a CodeCoverage object with the extracted data

        code_coverage = CodeCoverage(appName=xcresult_path, id=1, filenames=filenames,
                                     totalCoverage=0)
        for match in matches:
            filename = os.path.basename(match[0])
            coverage = match[2]
            if filename.endswith(".app"):
                code_coverage.appName = filename
                code_coverage.totalCoverage = coverage
            else:
                filename_obj = Filename(name=filename, coverage=coverage)
                filenames.append(filename_obj)

        # Access the properties of the CodeCoverage object
        print("AppName: ", code_coverage.appName)
        print("ID: ", code_coverage.id)
        print("Timestamp: ", code_coverage.timestamp)
        print("Total Coverage: ", code_coverage.totalCoverage)
        for filename_obj in code_coverage.filenames:
            print("Filename: ", filename_obj.name)
            print("Coverage: ", filename_obj.coverage)
