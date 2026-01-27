#!/bin/bash
# Full pipeline: download MIRA -> evaluate with qwen3_vl (8 workers, all 3 scenarios) -> accuracy with GPT-4o judge (1 worker) -> save to results.txt
#
# Required env:
#   - Azure: set in model_config.py for qwen3_vl (api_key, api_version, azure_endpoint, model_name)
#   - OPENAI_API_KEY: for acc.py GPT-4o judge (--use-llm-judge)
#
# Prereq: pip install -r requirements.txt

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

MIRA_DIR="./MIRA"
EVAL_OUTPUT_DIR="./eval_output"
RESULTS_FILE="./results.txt"

echo "========== 0. Check dependencies =========="
python -c "import huggingface_hub, openai, tqdm, PIL" || { echo "Run: pip install -r requirements.txt"; exit 1; }

echo ""
echo "========== 1. Download MIRA dataset =========="
python download_data.py

echo ""
echo "========== 2. Evaluate with qwen3_vl (8 workers, direct_answer + text_cot + visual_cot) =========="
python eval_azure_api.py \
  -b "$MIRA_DIR" \
  -o "$EVAL_OUTPUT_DIR" \
  -w 8 \
  -m qwen3_vl

echo ""
echo "========== 3. Accuracy with GPT-4o judge (1 worker), save to $RESULTS_FILE =========="
if [ -z "${OPENAI_API_KEY:-}" ]; then
  echo "Error: OPENAI_API_KEY is not set. Required for acc.py --use-llm-judge (GPT-4o)."
  exit 1
fi
python acc.py \
  -r "$EVAL_OUTPUT_DIR" \
  --use-llm-judge \
  -w 1 \
  2>&1 | tee "$RESULTS_FILE"

echo ""
echo "Done. Full results saved to $RESULTS_FILE"
