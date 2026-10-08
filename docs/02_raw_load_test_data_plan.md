# Raw Load Test Data Plan

Purpose:
Create synthetic operational load data containing realistic formatting,
data-quality, and business-rule issues for data-cleaning and ETL practice.

Target:
Approximately 60 raw load records.

Source:
Synthetic portfolio data only.

Planned Issues:

- Leading/trailing spaces
- Inconsistent capitalization
- Duplicate spaces
- Inconsistent date/time formats
- Load tags with missing leading zeros
- Duplicate rows
- Missing values
- Invalid driver
- Invalid mill
- Invalid product
- Duplicate load tag within contract
- Mill/product mismatch
- Driver authorization mismatch

Goal:
Profile, clean, validate, stage, transform, and load approved records
into dbo.Load.

## Initial Data Profiling Findings

- DriverName:
  - One Andre Lewis entry has an extra space between first and last name
  - One Jordan Price entry is all caps
  - One DriverName is blank

- MillName:
  - One Pine Valley entry is missing the word "Mill"
  - One River City Mill entry is all caps

- ProductCode:
  - One PPW entry is lowercase
  - One entry contains "Pine Sawtimber" instead of a product code

- LoadTag:
  - One entry is "5" instead of a 4-character tag such as "0005"

- Missing values:
  - One blank DriverName

- Exact duplicate:
  - CNT-2001 / 0004 appears twice with identical values

- Duplicate business keys with conflicting data:
  - CNT-2001 / 0005
  - CNT-2002 / 0109
  - CNT-2002 / 0110
  - CNT-2002 / 0112
  - CNT-2003 / 0215

- LoadTag normalization issue:
  - 5 should likely normalize to 0005
  - must check whether CNT-2001 / 0005 already exists

- Other observations:
  - One LoadDate uses dashes instead of slashes
  - One LoadTime appears left-justified and formatted differently, suggesting it may be stored as text
