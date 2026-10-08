# TimberDataPlatform — Initial Schema Plan

## Project Purpose

Create a realistic timber operations, settlement, and financial analytics
database using synthetic data.

The system should support operational tracking, financial calculations,
reconciliation, QA testing, and reporting.

## Initial Business Goals

The database should eventually support questions such as:

- What loads were hauled during a given period?
- Which driver hauled each load?
- Which mill or destination received the load?
- What wood/product type was hauled?
- How many tons were delivered?
- Which contract and compartment did the load belong to?
- What hauling or production rate applied?
- What amount should have been paid?
- What amount was actually reported or settled?
- Were there penalties, bonuses, culls, or other adjustments?
- Are there differences between expected and actual amounts?
- How are production and payments trending over time?

## Initial Scope

Version 1 will focus on:

- Companies
- Drivers
- Mills / destinations
- Contracts
- Compartments
- Wood / product types
- Loads
- Rates
- Settlements
- Settlement adjustments

Later versions may add:

- Trucks
- Equipment
- Customers
- Invoices
- Payments
- User accounts
- Audit history
- Additional financial modules

## Candidate Core Entities

### Company

Represents a trucking company, timber company, mill company, or other
business entity as needed.

### Driver

Represents the person hauling a load.

### Destination

Represents the mill or other location receiving timber.

### Contract

Represents the timber or business contract associated with loads.

### Compartment

Represents the tract, compartment, or subdivision associated with a contract.

### ProductType

Represents wood/product classifications such as pine pulpwood, hardwood,
sawlogs, or other synthetic product categories.

### Load

Represents an individual timber load and will likely be the primary
transactional record.

### Rate

Represents rates used to calculate hauling, cutting/loading, or other pay.

### Settlement

Represents settlement information received from a destination or mill.

### SettlementAdjustment

Represents penalties, bonuses, culls, overweight charges, or similar
adjustments.

## Early Relationship Ideas

- One Company can have many Drivers.
- One Contract can have many Compartments.
- One Destination can receive many Loads.
- One Driver can haul many Loads.
- One ProductType can appear on many Loads.
- One Contract / Compartment can be associated with many Loads.
- One Settlement can contain many settlement line items or loads.
- One Settlement may contain multiple adjustments.

## Questions Still To Resolve

- Should trucking companies and mills share one Company table or use separate tables?
- Should rates belong to contracts, destinations, products, drivers, or combinations?
- Should settlements link directly to loads or through settlement line items?
- How should expected pay versus actual settlement amount be represented?
- How should penalties and bonuses be modeled?
- What fields are needed to uniquely identify a load?
- Which fields should be required versus optional?
- Which business rules should be enforced by SQL Server constraints?

# Confirmed Version 1 Business and Data Model Decisions

## Organizational Structure

The system will be designed from the perspective of a fictional corporate
timber organization.

The organizational hierarchy is:

CorporateCompany
    -> Region
        -> TimberCompany

A CorporateCompany may operate across multiple regions and states.

State is treated as geographic data rather than as an organizational level.

## Timber Companies and Trucking Companies

A TimberCompany may work with multiple TruckingCompanies.

A TruckingCompany may work with multiple TimberCompanies.

This is therefore a many-to-many relationship and will eventually require
a junction table between TimberCompany and TruckingCompany.

## Drivers

A Driver belongs to one current TruckingCompany in Version 1.

Drivers may move between trucking companies in real life, but driver
employment history is outside Version 1 scope.

Driver names are not unique.

Each Driver will have:

- A unique internal DriverID
- A human-friendly DriverCode
- FirstName
- LastName
- Current TruckingCompany

DriverCode should be unique within a TruckingCompany rather than across
the entire corporation.

## Mill Companies and Mills

MillCompany and Mill are separate entities.

A MillCompany may operate multiple Mills.

Each Mill will have structured location information such as:

- MillName
- City
- State

Loads will reference the individual Mill rather than only the MillCompany.

## Product Types

Product names and codes are generally standardized.

ProductType will therefore be maintained as shared reference data.

A Mill may accept multiple ProductTypes, and a ProductType may be
accepted by multiple Mills.

This requires a many-to-many MillProductType relationship.

Version 1 does not need historical effective dates for mill/product
acceptance rules.

## Tracts and Contracts

Tract represents the physical property.

A Contract represents a business agreement between Corporate and a
TimberCompany for work on a Tract.

A Tract may have multiple Contracts over time, but only one Contract may
be active on the same Tract at a given time.

Contract will include:

- TimberCompany
- Tract
- Contract Number
- Start Date
- Expiration Date
- Status

Landowner management is outside Version 1 scope.

## Compartments

A Tract may contain one or more Compartments.

Multiple compartments were uncommon operationally but did occur.

Compartment will therefore be supported but kept lightweight.

Load may optionally reference a Compartment.

Compartment does not drive Version 1 rate, payment, or reconciliation logic.

## Contract-to-Mill Routes and Haul Rates

Corporate provides an authoritative hauling matrix for each Contract.

Haul rates are primarily driven by mileage between the Tract and Mill.

Mileage is also provided so operational staff can verify that the route
distance appears correct.

ContractMillRoute will represent:

- Contract
- Mill
- Miles
- HaulRate

All approved TruckingCompanies receive the same haul rate for the same
route in Version 1.

TruckingCompany is therefore not part of the haul-rate definition.

## Timber Company Cut/Saw/Load Rates

Cut/Saw/Load rates vary by ProductType.

These rates are separate from hauling rates.

The system should preserve separate:

- Cut/Saw/Load Rate
- Haul Rate

Total Cut and Haul pay should be calculated rather than independently
stored where practical.

## Load

Load represents the internally known operational record created when
timber leaves the Tract.

At load time, the business knows:

- Load Date
- Load Time
- Product Type
- Load Tag ID
- Intended Mill
- Driver
- Contract
- Optional Compartment

One Driver is associated with each Load.

One ProductType is associated with each Load.

The physical truck number is outside Version 1 scope.

## Load Tag

Load tags are four-digit business identifiers.

Load tag numbers may be reused across Contracts but were not reused
within the same Contract.

Load will use an internal LoadID as its primary key.

The business uniqueness rule for load tags is:

ContractID + LoadTagID

LoadTagID should be stored as text so leading zeros can be preserved.

## Mill Ticket

MillTicket represents the mill-confirmed version of a delivered Load.

The MillTicket is separate from Load because reconciliation compares
internal expected data with mill-reported data.

MillTicket will preserve the mill-reported:

- Mill
- Driver
- ProductType
- Scale Ticket Number
- Net Tons
- Delivery Date
- Arrival Time when available

Scale ticket numbers are not assumed to be globally unique.

The likely business uniqueness rule is:

MillID + ScaleTicketNumber

ScaleTicketNumber should be stored as text.

## Load and Mill Ticket Reconciliation

The physical LoadTag was stapled to the MillTicket and returned by the
Driver.

This provided the operational link between the internally tracked Load and
the MillTicket.

Weekly reconciliation compared:

- Mill
- Driver
- Product Type
- Ticket information
- Tons

Load represents what the timber operation expected.

MillTicket represents what the Mill confirmed.

These values should remain separate so mismatches can be detected rather
than overwritten.

## Weekly Settlement and Reconciliation

Each Contract has its own weekly settlement/reconciliation process.

A Contract may have many weekly reconciliations over its lifetime.

Each weekly reconciliation is identified internally by ReconciliationID
and includes a SettleWeekEndingDate.

A settlement may contain:

- Multiple Drivers
- Multiple TruckingCompanies
- Multiple Mills
- Multiple ProductTypes
- Multiple MillTickets

The weekly control objective is to determine:

1. Did settlement tons match internally calculated tons?
2. Did settlement pay match internally calculated pay after valid
   adjustments?

Version 1 will store aggregate weekly totals rather than detailed
settlement-line adjustments.

WeeklyReconciliation will contain values such as:

- ReconciliationID
- ContractID
- SettleWeekEndingDate
- InternalTotalTons
- SettlementTotalTons
- ExpectedGrossPay
- SettlementGrossPay
- LoggerCullTons
- TractCullTons
- OverweightTons
- PenaltyAmount
- BonusAmount
- SettlementNetPay
- Notes

Calculated reconciliation values such as:

- TonsDifference
- PayDifference
- AdjustedExpectedPay
- Pass/Fail status

should be derived using SQL rather than manually stored when practical.

Detailed settlement-line importing and parser integration are deferred to
a later project version.
