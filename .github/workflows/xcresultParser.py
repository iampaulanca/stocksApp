import subprocess
import json
import argparse
import re
import os
import datetime


class CodeCoverage:
    def __init__(self, appName, id, filenames, linesCovered, totalLines):
        self.appName = appName
        self.id = id
        self.filenames = filenames
        self.linesCovered = linesCovered
        self.totalLines = totalLines
        self.timestamp = datetime.datetime.now()


class Filename:
    def __init__(self, name, linesCovered, totalLines):
        self.name = name
        self.linesCovered = linesCovered
        self.totalLines = totalLines


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

        code_coverage = CodeCoverage(appName=xcresult_path, id=1, filenames=filenames, linesCovered=0, totalLines=0)
        for match in matches:
            filename = os.path.basename(match[0])
            coverageString = match[2]

            cov_match = re.match(r'(\d+\.\d+)% \((\d+)/(\d+)\)', coverageString)
            total_coverage = 0
            lines_covered = 0
            total_lines = 0

            if cov_match:
                total_coverage = float(cov_match.group(1))
                lines_covered = int(cov_match.group(2))
                total_lines = int(cov_match.group(3))

            if filename.endswith(".app"):
                code_coverage.appName = filename
                code_coverage.linesCovered = lines_covered
                code_coverage.totalLines = total_lines
            else:
                filename_obj = Filename(name=filename, linesCovered=0, totalLines=0)
                filename_obj.totalLines = total_lines
                filename_obj.linesCovered = lines_covered
                filenames.append(filename_obj)

        # Access the properties of the CodeCoverage object
        print("AppName: ", code_coverage.appName)
        print("ID: ", code_coverage.id)
        print("Timestamp: ", code_coverage.timestamp)
        total_coverage = (code_coverage.linesCovered / code_coverage.totalLines) * 100
        total_coverage_rounded = round(total_coverage, 2)
        print(f"Lines Covered: {code_coverage.linesCovered}/{code_coverage.totalLines}")
        print(f"Total Coverage: {total_coverage_rounded}%")
        print()
        for filename_obj in code_coverage.filenames:
            print("Filename: ", filename_obj.name)
            print(f"Lines Covered: {filename_obj.linesCovered}/{filename_obj.totalLines}")
            total_coverage = (filename_obj.linesCovered / filename_obj.totalLines) * 100
            total_coverage_rounded = round(total_coverage, 2)
            print(f"Total Coverage: {total_coverage_rounded}%")
            print()
