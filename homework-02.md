
## Pipeline Tree

![pipeline-tree](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/f9514f92-ce71-4e92-8cd9-2b5fa4c03be4)

## Blocks

```
import io
import pandas as pd
import requests

if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@data_loader
def load_data_from_api(*args, **kwargs):
    """
    Template for loading data from API
    """
    taxi_dtypes = {
        'VendorID': pd.Int64Dtype(),
        'pasangger_count': pd.Int64Dtype(),
        'trip_distance': float,
        'RateCodeID': pd.Int64Dtype(),
        'store_and_fwd+flag': str,
        'PULocationID': pd.Int64Dtype(),
        'DOLocationID': pd.Int64Dtype(),
        'payment_type': pd.Int64Dtype(),
        'fare_mount': float,
        'extra': float,
        'mta_tax': float,
        'tip_amount': float,
        'tolls_amount': float,
        'improvement_surcharge': float,
        'total_amount': float,
        'congestion_surcharge': float
    }

    parse_dates = ["lpep_pickup_datetime", "lpep_dropoff_datetime"]

    # Open the file for reading
    url_file = open('taxi_url.txt', 'r')

    # Get the first line of the file using the next() function
    first_line = next(url_file)
    
    # Read first line
    df = pd.read_csv(first_line, sep=',', compression='gzip', dtype=taxi_dtypes, parse_dates=parse_dates)
    # df = pd.read_csv(first_line, sep=',', compression='gzip', dtype=taxi_dtypes, parse_dates=True, keep_date_col=True)

    # Open file and put to link
    with open('taxi_url.txt', 'r') as text:
        links = text.read().splitlines()    
    
    # Read after first line
    for url in links[1:]:
        df1 = pd.read_csv(url, sep=',', compression='gzip', dtype=taxi_dtypes, parse_dates=parse_dates)
        # df1 = pd.read_csv(url, sep=',', compression='gzip', dtype=taxi_dtypes, parse_dates=True, keep_date_col=True)
        df = pd.concat([df, df1], sort=False)

    # Return output    
    return df
```

