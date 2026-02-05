import json
import pandas as pd

def flatten_json(data, parent_key='', sep='.'):
    items = {}
    if isinstance(data, dict):
        for k, v in data.items():
            new_key = f"{parent_key}{sep}{k}" if parent_key else k
            items.update(flatten_json(v, new_key, sep))
    elif isinstance(data, list):
        for i, v in enumerate(data):
            new_key = f"{parent_key}{sep}{i}"
            items.update(flatten_json(v, new_key, sep))
    else:
        items[parent_key] = data
    return items


# ---- Load JSON file ----
with open("latest_echis.json", "r", encoding="utf-8") as f:
    data = json.load(f)

# ---- Handle list or single object ----
if isinstance(data, list):
    flattened = [flatten_json(row) for row in data]
else:
    flattened = [flatten_json(data)]

# ---- Create DataFrame ----
df = pd.DataFrame(flattened)

# ---- Write to Excel ----
df.to_excel("latest_echis.xlsx", index=False)

print("✅ latest_echis.json extracted to latest_echis.xlsx")
