insert into sample_attr_type (type) values ('Misc'), ('DOS'), ('weight'), 
('BMI_kg_per_m2'), ('H1C_mg_per_dL'), ('FI'), ('duration_of_diabetes'), 
('is_OR_sample'), ('WGS_also_done'), ('V1-V2_Sequencing_Identity'),
('sample_type'), ('container'), ('non_publication_justification'),
('culture_results_confirmed'), ('agreement_between_culture_and_16S'), 
('sex'), ('ethnicity'), ('height_inches');

insert into publication (publication_id, publication_name) values (1, 'NA');

insert into patient (patient_id, patient_name) values (1, 'NA');

insert into seq_type (type) values ('16S'), ('16S_rRNA'), ('WGS'), 
('RNA-seq'), ('QC');
