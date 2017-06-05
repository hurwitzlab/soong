set foreign_key_checks=0;

drop table if exists project;
create table project (
  project_id int unsigned not null auto_increment primary key,
  project_name varchar(100) not null,
  unique (project_name)
) ENGINE=InnoDB;

drop table if exists seq_type;
create table seq_type (
  seq_type_id int unsigned not null auto_increment primary key,
  type varchar(100) not null,
  unique (type)
) ENGINE=InnoDB;

insert into seq_type (seq_type_id, type) values (1, "Unknown");

drop table if exists sample;
create table sample (
  sample_id int unsigned not null auto_increment primary key,
  project_id int unsigned not null,
  seq_type_id int unsigned not null default 1,
  sample_name varchar(100) not null,
  sample_num varchar(100),
  barcode varchar(100),
  unique (project_id, sample_name),
  key (project_id),
  key (seq_type_id),
  foreign key (project_id) references project (project_id),
  foreign key (seq_type_id) references seq_type (seq_type_id)
) ENGINE=InnoDB;

drop table if exists seq_run;
create table seq_run (
  seq_run_id int unsigned not null auto_increment primary key,
  sample_id int unsigned not null,
  report varchar(255),
  key (sample_id),
  foreign key (sample_id) references sample (sample_id)
) ENGINE=InnoDB;

drop table if exists bam_file;
create table bam_file (
  bam_file_id int unsigned not null auto_increment primary key,
  seq_run_id int unsigned not null,
  publication_id int unsigned not null,
  file_name varchar(255) not null,
  qc_command text,
  num_total_reads int unsigned,
  num_mapped_reads int unsigned,
  culture_result text,
  other_results text,
  analyses text,
  unique (seq_run_id, file_name),
  key (seq_run_id),
  key (publication_id),
  foreign key (seq_run_id) references seq_run (seq_run_id),
  foreign key (publication_id) references publication (publication_id)
) ENGINE=InnoDB;

drop table if exists publication;
create table publication (
  publication_id int unsigned not null auto_increment primary key,
  publication_name varchar(255)
);
