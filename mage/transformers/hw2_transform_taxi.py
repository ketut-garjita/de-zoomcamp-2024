if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@transformer
def transform(data, *args, **kwargs):
    """ Using Numpy
    data = data[np.logical_not(data['passenger_count'].isin([0]))]
    df = data[np.logical_not(data['trip_distance'].isin([0]))]
    return df
    """
    # Replace NaN value into 0 (zero) in passenger_count & trip_distance columns 
    data['passenger_count'] = data['passenger_count'].fillna(0)
    data['trip_distance'] = data['trip_distance'].fillna(0)

    # Remove rows tha have 0 (zero) values
    data = data[data['passenger_count'] != 0]
    data = data[data['trip_distance'] != 0]
    
    # Create a new column lpep_pickup_date by converting lpep_pickup_datetime to a date
    from datetime import date
    data['lpep_pickup_date'] = data['lpep_pickup_datetime'].dt.date
    
    # Rename column VendorID to vendor_id
    data.columns = data.columns.str.replace("VendorID", "vendor_id")

    # Return output
    return data
