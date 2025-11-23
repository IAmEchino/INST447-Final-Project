import pandas as pd
from collections import Counter
import ast

# --- AIRBNB CLEANING ---
df = pd.read_csv("listings_with_address.csv")

# Keep relevant columns (including full_address)
df = df[["id", "full_address", "zipcode", "latitude", "longitude", "property_type", "price", "amenities"]]
df = df.drop_duplicates().dropna(subset=["zipcode", "price"])

# Clean price
df["price"] = (
    df["price"]
    .astype(str)
    .replace(r'[\$,]', '', regex=True)
)
df["price"] = pd.to_numeric(df["price"], errors="coerce")

# Clean zipcodes
df["zipcode"] = (
    df["zipcode"]
    .astype("Int64")
    .astype(str)
    .str.zfill(5)
)

# Remove invalid/zero prices
df = df[df["price"] > 0]

# --- Remove top 1% outliers per zipcode ---
def remove_outliers(group):
    upper = group["price"].quantile(0.99)
    return group[group["price"] <= upper]

df = df.groupby("zipcode", group_keys=False).apply(remove_outliers)

# Clean property_type text
df["property_type"] = df["property_type"].str.strip().str.title()

# Parse amenities safely
df["amenities"] = df["amenities"].apply(
    lambda x: ast.literal_eval(x) if isinstance(x, str) else []
)

# Count amenities
def count_amenities(series):
    all_amenities = [a for sublist in series for a in sublist]
    return dict(Counter(all_amenities))

# --- Airbnb Aggregation (median only, keep full addresses) ---
airbnb_agg = df.groupby("zipcode").agg(
    airbnb_count=("id", "count"),
    airbnb_median_price=("price", "median"),
    avg_latitude=("latitude", "mean"),
    avg_longitude=("longitude", "mean"),
    most_common_property_type=("property_type", lambda x: x.mode()[0] if not x.mode().empty else None),
    amenities_count=("amenities", count_amenities),
    addresses=("full_address", lambda x: list(x))  # ✅ keep all addresses in a list
).reset_index()

# --- ZILLOW CLEANING / IMPORT ---
real_estate_df = pd.read_csv("zillow_data_clean_final - zillow_data_clean_final (1).csv")

# Match zipcode format
real_estate_df["zipcode"] = (
    real_estate_df["zipcode"]
    .astype(str)
    .str.zfill(5)
)

# Zillow aggregation
zillow_agg = real_estate_df.groupby("zipcode").agg(
    zillow_count=("price", "count"),
    zillow_median_price=("price", "median"),
    avg_beds=("beds", "mean"),
    avg_baths=("baths", "mean"),
    avg_latitude=("latitude", "mean"),
    avg_longitude=("longitude", "mean")
).reset_index()

# --- MERGE DATASETS ---
merged_df = pd.merge(airbnb_agg, zillow_agg, on="zipcode", how="inner")

# Drop any lingering "mean" columns except lat/long
cols_to_drop = [c for c in merged_df.columns if "mean" in c and "latitude" not in c and "longitude" not in c]
merged_df = merged_df.drop(columns=cols_to_drop, errors="ignore")

# Rename for clarity
merged_df = merged_df.rename(columns={
    "avg_latitude_x": "airbnb_avg_latitude",
    "avg_longitude_x": "airbnb_avg_longitude",
    "avg_latitude_y": "zillow_avg_latitude",
    "avg_longitude_y": "zillow_avg_longitude"
})

# Save outputs
merged_df.to_csv("zillow_and_airbnb_data.csv", index=False)
df.to_csv("airbnb_data_clean.csv", index=False)
real_estate_df.to_csv("zillow_data_clean.csv", index=False)


# import requests
# import time

# # Load your Airbnb listings
# df = pd.read_csv("listings.csv") 

# # Take only the first 3 rows for testing
# # df_sample = df.head(3).copy()

# # Add new columns for ZIP and full address
# df['zipcode'] = None
# df['full_address'] = None

# # Your Google Maps API key
# API_KEY = "AIzaSyBvL7u1foo9rccH2sikdEdKeoB7DnXZWyw"

# # Function to get full address and ZIP code
# def get_address_info(lat, lon):
#     url = f"https://maps.googleapis.com/maps/api/geocode/json?latlng={lat},{lon}&key={API_KEY}"
#     response = requests.get(url).json()
#     if response.get('status') == 'OK' and len(response['results']) > 0:
#         full_address = response['results'][0].get('formatted_address')
#         zipcode = None
#         for result in response['results']:
#             for comp in result['address_components']:
#                 if 'postal_code' in comp['types']:
#                     zipcode = comp['long_name']
#                     break
#             if zipcode:
#                 break
#         return full_address, zipcode
#     return None, None

# # Loop through sample
# for i, row in df.iterrows():
#     full_address, zipcode = get_address_info(row['latitude'], row['longitude'])
#     df.at[i, 'full_address'] = full_address
#     df.at[i, 'zipcode'] = zipcode
#     time.sleep(0.1)  # short pause for API safety

# # Save sample results
# df.to_csv("listings_with_address.csv", index=False)

# # Show output
# print(df[['id', 'latitude', 'longitude', 'full_address', 'zipcode']].tail())
# print(len(df))
