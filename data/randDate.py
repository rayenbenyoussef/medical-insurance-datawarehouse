import pandas as pd
import random
from datetime import date, timedelta

df = pd.read_csv('data/insurance.csv')

def random_date():
    start = date(2020, 1, 1)
    end = date(2025, 12, 31)
    return start + timedelta(days=random.randint(0, (end - start).days))

df['intakedate'] = [random_date() for _ in range(len(df))]

df.to_csv('data/insurance.csv', index=False)