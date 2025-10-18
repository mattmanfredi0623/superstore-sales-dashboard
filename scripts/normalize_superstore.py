import csv, pathlib, re
from datetime import datetime

ROOT = pathlib.Path(__file__).resolve().parents[1]
IN  = ROOT / "data" / "SuperStoreOrders.csv"
OUT = ROOT / "data" / "SuperStoreOrders_clean.csv"
OUT.parent.mkdir(parents=True, exist_ok=True)

CANON = [
  "order_id","order_date","ship_date","ship_mode","customer_name","segment",
  "state","country","market","region","product_id","category","sub_category",
  "product_name","sales","quantity","discount","profit","shipping_cost",
  "order_priority","year"
]

def detect_dialect(fp):
  sample = fp.read(65536); fp.seek(0)
  try: return csv.Sniffer().sniff(sample)
  except: 
    d = csv.excel; d.delimiter = ','; return d

def norm_header(h):
  h = (h or '').strip().lower()
  h = h.replace('-', '_').replace(' ', '_')
  h = re.sub(r'[^0-9a-z_]', '', h)
  h = h.replace('subcategory','sub_category').replace('shippingcost','shipping_cost')
  h = h.replace('orderpriority','order_priority')
  return h

def parse_date(s):
  s = (s or '').strip().split(' ')[0].replace('.', '/')
  if not s: return ''
  fmts = ("%m/%d/%Y","%m/%d/%y","%Y-%m-%d","%Y/%m/%d","%m-%d-%Y","%d-%m-%Y","%d/%m/%Y")
  for f in fmts:
    try: return datetime.strptime(s, f).strftime("%Y-%m-%d")
    except: pass
  m = re.match(r'^(\d{1,2})[/-](\d{1,2})[/-](\d{2,4})$', s)
  if m and int(m.group(1))>12 and int(m.group(2))<=12:
    try: return datetime.strptime(f"{m.group(2)}/{m.group(1)}/{m.group(3)}", "%m/%d/%Y").strftime("%Y-%m-%d")
    except: pass
  return ''

def clean_num(s):
  s = (s or '').replace('$','').replace(',','').strip()
  if s.startswith('(') and s.endswith(')'): s = '-' + s[1:-1]
  return s

with open(IN, 'r', encoding='utf-8-sig', newline='') as fin:
  r = csv.reader(fin, detect_dialect(fin))
  raw_header = next(r)
  idx = {norm_header(c): i for i, c in enumerate(raw_header)}
  missing = [c for c in CANON if c not in idx]
  if missing: raise SystemExit(f"Missing columns: {missing}")

  with open(OUT, 'w', encoding='utf-8', newline='') as fout:
    w = csv.writer(fout, lineterminator='\n'); w.writerow(CANON)
    rows = 0
    for row in r:
      row += [''] * (len(raw_header) - len(row))
      out = [row[idx[c]].strip() for c in CANON]
      out[1] = parse_date(out[1])
      out[2] = parse_date(out[2])
      for j in [14,15,16,17,18]:
        out[j] = clean_num(out[j])
      w.writerow(out); rows += 1
print(f"Wrote {rows} rows -> {OUT}")