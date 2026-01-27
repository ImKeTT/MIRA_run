from huggingface_hub import HfApi

api = HfApi()

repo_id = "YiyangAiLab/MIRA"

files = api.list_repo_files(repo_id, repo_type="dataset")

# extract top-level folders
tasks = sorted({
    f.split("/")[0]
    for f in files
    if "/" in f and not f.startswith(".")
})

print("Found tasks:")
for t in tasks:
    print(" -", t)
