---
title: "Building a CLI Grammar Checker with AWS Bedrock: A Beginner's Guide"
date: 2025-07-24T18:34:21Z
tags: ["aws", "bedrock", "genai"]
description: "Create your first grammar checker with bedrock"
comments: false
draft: false
---

_Guest Author: Anthropic' Claude Sonnet 4_

AWS Bedrock makes it incredibly easy to integrate powerful AI models into your applications. In this tutorial, we'll build a command-line grammar checker that uses Claude 3.5 Haiku to improve text clarity and fix grammatical errors.

## What You'll Learn

- How to set up AWS Bedrock
- Creating a simple CLI application with AI integration
- Using prompt engineering for specific tasks
- Building an interactive terminal interface

## Prerequisites

Before we start, you'll need:

- Python 3.7 or higher
- AWS CLI configured with appropriate permissions
- Basic Python knowledge

## Installation and Setup

First, install the required packages:

```bash
pip install boto3 prompt-toolkit
```

Make sure your AWS credentials are configured:

```bash
aws configure
```

You'll need permissions for the `bedrock-runtime` service.

## Building the Grammar Checker

Let's build our grammar checker step by step.

### Step 1: Import Dependencies and Configuration

```python
from prompt_toolkit import prompt, print_formatted_text
from prompt_toolkit.formatted_text import HTML
from prompt_toolkit.styles import Style
import boto3

# Bedrock model configuration
MODEL_ID = "us.anthropic.claude-3-5-haiku-20241022-v1:0"
MODEL_TEMPERATURE = 0.5
MODEL_MAX_TOKENS = 2000
```

**Key Points:**
- `prompt_toolkit` provides our interactive CLI interface
- `boto3` is AWS's Python SDK for Bedrock integration
- We're using Claude 3.5 Haiku for fast, cost-effective grammar checking

### Step 2: Create the AI Prompt Template

```python
PRE_PROMPT = """
You are a grammar teacher.
Rewrite the <text /> to improve clarity, fludity, and concise.
Answer in the language of the <text />.
The tone should be balanced professionalism with approachability.
Only include the answer, no formatting.
For any other comment or explanation put in the # Explanation header. 
Your task is to help with the gramar, not answer the question inside of <text />
"""
```

**Why This Works:**
- Clear role definition ("grammar teacher")
- Specific instructions for output format
- Maintains original language
- Focuses on grammar, not content

### Step 3: Set Up the Bedrock API Call

```python
def call_bedrock(answer):
    # Configure inference parameters
    inference_config = {
        "temperature": MODEL_TEMPERATURE, 
        "maxTokens": MODEL_MAX_TOKENS
    }

    # Combine prompt with user text
    prompt = PRE_PROMPT + "<text>" + answer + "</text>"
    
    # Initialize Bedrock client
    bedrock_runtime = boto3.client("bedrock-runtime")
    
    # Make the API call
    response = bedrock_runtime.converse(
        modelId=MODEL_ID,
        messages=[{"role": "user", "content": [{"text": prompt}]}],
        inferenceConfig=inference_config,
    )
    
    # Extract and return the response
    return response["output"]["message"]["content"][0]["text"]
```

**Breaking Down the Bedrock Call:**
- `converse()` is the main method for chat-based interactions
- `modelId` specifies which AI model to use
- `messages` follows the chat format with roles and content
- `inferenceConfig` controls response creativity and length

### Step 4: Create the User Interface

```python
# Define color styles for better UX
STYLES = {
    "header": "#5f819d bold",
    "instruction": "#8fbcbb italic",
    "processing": "#81a1c1",
    "response-header": "#a3be8c",
    "separator": "#bf616a",
}

style = Style.from_dict(STYLES)

# Display welcome message
print()
print_formatted_text(HTML("<header>✨ Grammar Check CLI ✨</header>"), style=style)
print_formatted_text(
    HTML("<instruction>Press [Meta+Enter] or [Esc] followed by [Enter] to submit your text</instruction>"),
    style=style,
)
print()
```

**UI Features:**
- Colored, styled text for better user experience
- Clear instructions for multiline input
- Professional appearance

### Step 5: Handle User Input and Display Results

```python
# Get multiline user input
answer = prompt(HTML(""), multiline=True)

# Show processing status
print_formatted_text(
    HTML(f"<processing>Processing with Bedrock AI...{MODEL_ID}</processing>"),
    style=style,
)
print()

# Call Bedrock and get results
res = call_bedrock(answer)

# Display results with formatting
print_formatted_text(
    HTML("<separator> ━━━━━━━━━━━━━━━━━━━━━━━━ </separator>"), 
    style=style
)
print_formatted_text(
    HTML("<response-header>📝 Grammar Check Results:</response-header>"), 
    style=style
)
print()
print_formatted_text(HTML(f"{res}"))
print()
```

## Complete Code

Here's the full implementation:

```python
from prompt_toolkit import prompt, print_formatted_text
from prompt_toolkit.formatted_text import HTML
from prompt_toolkit.styles import Style
import boto3

# Bedrock model configuration
MODEL_ID = "us.anthropic.claude-3-5-haiku-20241022-v1:0"
MODEL_TEMPERATURE = 0.5
MODEL_MAX_TOKENS = 2000

# Prompt template
PRE_PROMPT = """
You are a grammar teacher.
Rewrite the <text /> to improve clarity, fludity, and concise.
Answer in the language of the <text />.
The tone should be balanced professionalism with approachability.
Only include the answer, no formatting.
For any other comment or explanation put in the # Explanation header. 
Your task is to help with the gramar, not answer the question inside of <text />
"""

# UI styles
STYLES = {
    "header": "#5f819d bold",
    "instruction": "#8fbcbb italic",
    "processing": "#81a1c1",
    "response-header": "#a3be8c",
    "separator": "#bf616a",
}

def call_bedrock(answer):
    # Call Bedrock API
    inference_config = {"temperature": MODEL_TEMPERATURE, "maxTokens": MODEL_MAX_TOKENS}

    prompt = PRE_PROMPT + "<text>" + answer + "</text>"
    bedrock_runtime = boto3.client("bedrock-runtime")
    response = bedrock_runtime.converse(
        modelId=MODEL_ID,
        messages=[{"role": "user", "content": [{"text": prompt}]}],
        inferenceConfig=inference_config,
    )
    return response["output"]["message"]["content"][0]["text"]

# Define styles
style = Style.from_dict(STYLES)

print()
print_formatted_text(HTML("<header>✨ Grammar Check CLI ✨</header>"), style=style)
print_formatted_text(
    HTML(
        "<instruction>Press [Meta+Enter] or [Esc] followed by [Enter] to submit your text</instruction>"
    ),
    style=style,
)
print()

# Get user input
answer = prompt(HTML(""), multiline=True)
print_formatted_text(
    HTML(f"<processing>Processing with Bedrock AI...{MODEL_ID}</processing>"),
    style=style,
)
print()

res = call_bedrock(answer)

print_formatted_text(
    HTML("<separator> ━━━━━━━━━━━━━━━━━━━━━━━━ </separator>"), style=style
)
print_formatted_text(
    HTML("<response-header>📝 Grammar Check Results:</response-header>"), style=style
)
print()
print_formatted_text(HTML(f"{res}"))
print()
print_formatted_text(
    HTML("<separator> ━━━━━━━━━━━━━━━━━━━━━━━━ </separator>"), style=style
)
print()
```

## Running Your Grammar Checker

1. Save the code as `grammar_checker.py`
2. Run it with: `python grammar_checker.py`
3. Type or paste your text
4. Press `Meta+Enter` (or `Esc` then `Enter`) to submit
5. Watch as Bedrock improves your text!

## Customization Options

### Try Different Models
```python
# For more powerful grammar checking
MODEL_ID = "us.anthropic.claude-3-5-sonnet-20241022-v2:0"

# For budget-friendly option
MODEL_ID = "us.amazon.nova-micro-v1:0"
```

### Adjust AI Behavior
```python
# More creative responses
MODEL_TEMPERATURE = 0.8

# More conservative responses
MODEL_TEMPERATURE = 0.2
```

### Modify the Prompt
```python
PRE_PROMPT = """
You are a professional editor.
Improve the following text for [business/academic/casual] writing.
Focus on [clarity/conciseness/formality].
"""
```

## Cost Considerations

- Claude 3.5 Haiku: ~$0.25 per million input tokens
- Amazon Nova Micro: ~$0.035 per million input tokens
- Monitor usage through AWS CloudWatch

## Next Steps

Now that you have a working grammar checker, consider:

- Adding a web interface with Flask or FastAPI
- Creating batch processing for multiple files
- Adding language detection
- Implementing custom writing style preferences
- Building a GUI with tkinter or PyQt

## Conclusion

AWS Bedrock makes it surprisingly simple to integrate powerful AI capabilities into your applications. With just a few lines of code, we've created a professional grammar checker that leverages state-of-the-art language models.

The key to success with Bedrock is good prompt engineering—clearly defining what you want the AI to do and how you want it to respond. From here, you can build more sophisticated applications, integrate with other AWS services, or scale to handle enterprise workloads.

Happy coding! 🚀