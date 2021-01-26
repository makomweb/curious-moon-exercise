drop table chem_data cascade;
create table chem_data(
    name text,
    formula varchar(10),
    molecular_weight integer,
    peak integer,
    sensitivity numeric
);