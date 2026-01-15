import csv, json, re, unicodedata

def norm(s: str) -> str:
    s = (s or "").strip().lower()
    s = unicodedata.normalize("NFD", s)
    s = "".join(ch for ch in s if unicodedata.category(ch) != "Mn")  # quita tildes
    s = re.sub(r"\s+", " ", s)
    return s

inp = "cities_20000.csv"
out = "assets/data/cities.min.json"

rows = []
with open(inp, newline="", encoding="utf-8") as f:
    r = csv.DictReader(f)
    for row in r:
        name = row["city_name"].strip()
        cc = row["country_code"].strip()
        cf = row["country_full"].strip()
        sc = (row.get("state_code") or "").strip()
        lat = float(row["lat"])
        lon = float(row["lon"])
        cid = int(row["city_id"])

        display = f"{name}, {cf}"
        search = norm(f"{name} {cf}")

        rows.append({
            "id": cid,
            "name": name,
            "cc": cc,
            "cf": cf,
            "sc": sc,
            "lat": lat,
            "lon": lon,
            "d": display,   # display
            "s": search     # search
        })

with open(out, "w", encoding="utf-8") as f:
    json.dump(rows, f, ensure_ascii=False, separators=(",", ":"))

print("OK:", out, "cities:", len(rows))
