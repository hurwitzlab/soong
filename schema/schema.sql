SET foreign_key_checks = 0;

DROP TABLE IF EXISTS project;
CREATE TABLE project (
  project_id int(10) unsigned NOT NULL AUTO_INCREMENT,
  project_name varchar(100) NOT NULL,
  PRIMARY KEY (project_id),
  UNIQUE (project_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS patient;
CREATE TABLE patient (
  patient_id int(10) unsigned NOT NULL AUTO_INCREMENT,
  patient_name varchar(100) NOT NULL,
  PRIMARY KEY (patient_id),
  UNIQUE (patient_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS patient_attr_type;
CREATE TABLE patient_attr_type (
  patient_attr_type_id int(10) unsigned NOT NULL AUTO_INCREMENT,
  type varchar(100) NOT NULL,
  PRIMARY KEY (patient_attr_type_id),
  UNIQUE (type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS patient_attr;
CREATE TABLE patient_attr (
  patient_attr_id int(10) unsigned NOT NULL AUTO_INCREMENT,
  patient_id int(10) unsigned NOT NULL,
  patient_attr_type_id int(10) unsigned NOT NULL,
  value text NOT NULL,
  PRIMARY KEY (patient_attr_id),
  KEY (patient_id),
  KEY (patient_attr_type_id),
  FOREIGN KEY (patient_id) REFERENCES patient (patient_id) ON DELETE CASCADE,
  FOREIGN KEY (patient_attr_type_id) REFERENCES patient_attr_type (patient_attr_type_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS sample;
CREATE TABLE sample (
  sample_id int(10) unsigned NOT NULL AUTO_INCREMENT,
  project_id int(10) unsigned NOT NULL,
  patient_id int(10) unsigned NOT NULL DEFAULT 1,
  sample_acc varchar(100) NOT NULL,
  sample_num int unsigned,
  sample_collection_date date,
  PRIMARY KEY (sample_id),
  UNIQUE (project_id,sample_acc),
  KEY (project_id),
  FOREIGN KEY (project_id) REFERENCES project (project_id) ON DELETE CASCADE,
  FOREIGN KEY (patient_id) REFERENCES patient (patient_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS sample_attr_type;
CREATE TABLE sample_attr_type (
  sample_attr_type_id int(10) unsigned NOT NULL AUTO_INCREMENT,
  type varchar(100) NOT NULL,
  PRIMARY KEY (sample_attr_type_id),
  UNIQUE (type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS sample_attr;
CREATE TABLE sample_attr (
  sample_attr_id int(10) unsigned NOT NULL AUTO_INCREMENT,
  sample_id int(10) unsigned NOT NULL,
  sample_attr_type_id int(10) unsigned NOT NULL,
  value text NOT NULL,
  PRIMARY KEY (sample_attr_id),
  KEY (sample_id),
  KEY (sample_attr_type_id),
  FOREIGN KEY (sample_id) REFERENCES sample (sample_id) ON DELETE CASCADE,
  FOREIGN KEY (sample_attr_type_id) REFERENCES sample_attr_type (sample_attr_type_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS seq_type;
CREATE TABLE seq_type (
  seq_type_id int(10) unsigned NOT NULL AUTO_INCREMENT,
  type varchar(100) NOT NULL,
  PRIMARY KEY (seq_type_id),
  UNIQUE (type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS library;
CREATE TABLE library (
  library_id int(10) unsigned NOT NULL AUTO_INCREMENT,
  sample_id int(10) unsigned NOT NULL,
  seq_type_id int(10) unsigned NOT NULL DEFAULT '1',
  barcode varchar(100) DEFAULT NULL,
  PRIMARY KEY (library_id),
  KEY (sample_id),
  KEY (seq_type_id),
  UNIQUE (sample_id, barcode),
  FOREIGN KEY (sample_id) REFERENCES sample (sample_id) ON DELETE CASCADE,
  FOREIGN KEY (seq_type_id) REFERENCES seq_type (seq_type_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS seq_run;
CREATE TABLE seq_run (
  seq_run_id int(10) unsigned NOT NULL AUTO_INCREMENT,
  library_id int(10) unsigned NOT NULL,
  sequencing_report varchar(255) DEFAULT NULL,
  run_on_sequencer varchar(255) DEFAULT NULL,
  PRIMARY KEY (seq_run_id),
  KEY library_id (library_id),
  UNIQUE KEY `library_report` (library_id, sequencing_report),
  FOREIGN KEY (library_id) REFERENCES library (library_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS publication;
CREATE TABLE publication (
  publication_id int(10) unsigned NOT NULL AUTO_INCREMENT,
  publication_name varchar(255) DEFAULT NULL,
  PRIMARY KEY (publication_id),
  UNIQUE (publication_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS bam_file;
CREATE TABLE bam_file (
  bam_file_id int(10) unsigned NOT NULL AUTO_INCREMENT,
  seq_run_id int(10) unsigned NOT NULL,
  publication_id int(10) unsigned NOT NULL DEFAULT 1,
  filename varchar(255) NOT NULL,
  qc_command text,
  num_total_reads int(10) unsigned DEFAULT NULL,
  num_mapped_reads int(10) unsigned DEFAULT NULL,
  culture_result text,
  short_culture_result text,
  other_results text,
  analyses text,
  PRIMARY KEY (bam_file_id),
  UNIQUE (seq_run_id, filename),
  KEY (seq_run_id),
  KEY (publication_id),
  FOREIGN KEY (seq_run_id) REFERENCES seq_run (seq_run_id) ON DELETE CASCADE,
  FOREIGN KEY (publication_id) REFERENCES publication (publication_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
