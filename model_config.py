# -----------------------------------------------------------------------------
# Azure OpenAI (eval_azure_api.py)
# -----------------------------------------------------------------------------
MODEL_CONFIG = {
    "gpt4o": {
        "model_name": "",
        "api_key": "",
        "api_version": "",
        "azure_endpoint": ""
    },
    "qwen3_vl": {
        "model_name": "",
        "api_key": "",
        "api_version": "",
        "azure_endpoint": ""
    },
    # Add more models as needed
}

# -----------------------------------------------------------------------------
# Standard OpenAI judge (acc.py) – model name for LLM judging; API key from
# OPENAI_API_KEY or DIRECT_ASSIGNED_API_KEY in acc.py
# -----------------------------------------------------------------------------
JUDGE_CONFIG = {
    "model_name": "gpt-4o",
}