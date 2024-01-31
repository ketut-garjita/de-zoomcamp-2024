if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@transformer
def transform(data, *args, **kwargs):
    print("Rows with zero passangers:", data['passenger_count'].isin([0]).sum())
    
    return data[data['passenger_count'] > 0]