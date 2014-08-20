 DROP TABLE bal;
CREATE TABLE bal
(
  plate integer, -- Spectroscopic plate number
  fiber integer, -- Spectroscopic fiber number
  mjd integer, -- Spectroscopic MJD
  z double precision, -- QSO redshift (Schneider et al. 2010)
  specid bigint NOT NULL DEFAULT 0::bigint, -- Spectroscopic id (primary key)
  balcode integer, -- BAL flag (from Shen et al. 2011, ApJS, 194, 45). 0=nonBALQSO or no wavelength coverage; 1=CIV BALQSO; 2=MgII BALQSO; 3=both CIV and MgII BALQSO
  CONSTRAINT dr7bal_pkey PRIMARY KEY (specid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE bal
  OWNER TO yusra;
GRANT ALL ON TABLE bal TO yusra;
GRANT SELECT ON TABLE bal TO sdss;
COMMENT ON COLUMN bal.plate IS 'Spectroscopic plate number';
COMMENT ON COLUMN bal.fiber IS 'Spectroscopic fiber number';
COMMENT ON COLUMN bal.mjd IS 'Spectroscopic MJD';
COMMENT ON COLUMN bal.z IS 'QSO redshift (Schneider et al. 2010)';
COMMENT ON COLUMN bal.specid IS 'Spectroscopic id (primary key)';
COMMENT ON COLUMN bal.balcode IS 'BAL flag (from Shen et al. 2011, ApJS, 194, 45). 0=nonBALQSO or no wavelength coverage; 1=CIV BALQSO; 2=MgII BALQSO; 3=both CIV and MgII BALQSO';

DROP TABLE minibal;
CREATE TABLE minibal (
    plate integer DEFAULT 0 NOT NULL,
    fiber integer DEFAULT 0 NOT NULL,
    specid bigint,
    balcode integer
);


ALTER TABLE public.minibal OWNER TO sdss_dev;
ALTER TABLE ONLY minibal
    ADD CONSTRAINT dr7balauto_pkey PRIMARY KEY (plate, fiber);
REVOKE ALL ON TABLE minibal FROM PUBLIC;
GRANT ALL ON TABLE minibal TO sdss_dev;
GRANT SELECT ON TABLE minibal TO sdss;


-- DON'T DROP QSOS
CREATE TABLE qsos (
    specid bigint NOT NULL,
    sdssname character varying(64),
    ra double precision,
    decl double precision,
    redshift real,
    psfmag_u real,
    psfmagerr_u real,
    psfmag_g real,
    psfmagerr_g real,
    psfmag_r real,
    psfmagerr_r real,
    psfmag_i real,
    psfmagerr_i real,
    psfmag_z real,
    psfmagerr_z real,
    a_u real,
    lgnh real,
    firstmag real,
    first_sn real,
    first_sep real,
    lg_rass_rate real,
    rass_sn real,
    rass_sep real,
    twomassmag_j real,
    twomassmagerr_j real,
    twomassmag_h real,
    twomassmagerr_h real,
    twomassmag_k real,
    twomassmagerr_k real,
    twomass_sep real,
    twomass_flag bigint,
    m_i real,
    delgi real,
    morphology smallint,
    scienceprimary smallint,
    mode smallint,
    uniform smallint,
    bestprimtarget bigint,
    ts_b_lowz smallint,
    ts_b_hiz smallint,
    ts_b_first smallint,
    ts_b_rosat smallint,
    ts_b_serendip smallint,
    ts_b_star smallint,
    ts_b_gal smallint,
    run_best integer,
    mjd_best integer,
    mjd integer,
    plate integer,
    fiber integer,
    rerun_best integer,
    camcol_best integer,
    field_best integer,
    obj_best integer,
    targprimtarget bigint,
    ts_t_lowz smallint,
    ts_t_hiz smallint,
    ts_t_first smallint,
    ts_t_rosat smallint,
    ts_t_serendip smallint,
    ts_t_star smallint,
    ts_t_gal smallint,
    t_psfmag_u real,
    t_psfmagerr_u real,
    t_psfmag_g real,
    t_psfmagerr_g real,
    t_psfmag_r real,
    t_psfmagerr_r real,
    t_psfmag_i real,
    t_psfmagerr_i real,
    t_psfmag_z real,
    t_psfmagerr_z real,
    objid bigint,
    oldname_type character varying(24),
    oldname_desig character varying(24),
    lon double precision,
    lat double precision,
    geopoint geography
);

ALTER TABLE public.qsos OWNER TO sdss_dev;
COMMENT ON COLUMN qsos.specid IS 'Spectroscopic id (primary key)';
COMMENT ON COLUMN qsos.sdssname IS 'DR7 Object Designation   hhmmss.ss+ddmmss.s  (J2000; truncated coordinates)';
COMMENT ON COLUMN qsos.ra IS 'R.A.(J2000) in degrees';
COMMENT ON COLUMN qsos.decl IS 'Dec.(J2000) in degrees';
COMMENT ON COLUMN qsos.redshift IS 'Redshift';
COMMENT ON COLUMN qsos.psfmag_u IS 'u PSF magnitude';
COMMENT ON COLUMN qsos.psfmagerr_u IS 'error in u PSF magnitude';
COMMENT ON COLUMN qsos.psfmag_g IS 'g PSF magnitude';
COMMENT ON COLUMN qsos.psfmagerr_g IS 'g PSF magnitude error';
COMMENT ON COLUMN qsos.psfmag_r IS 'r PSF magnitude';
COMMENT ON COLUMN qsos.psfmagerr_r IS 'r PSF magnitude error';
COMMENT ON COLUMN qsos.psfmag_i IS 'i PSF magnitude';
COMMENT ON COLUMN qsos.psfmagerr_i IS 'i PSF magnitude error';
COMMENT ON COLUMN qsos.psfmag_z IS 'z PSF magnitude';
COMMENT ON COLUMN qsos.psfmagerr_z IS 'z PSF magnitude error';
COMMENT ON COLUMN qsos.a_u IS 'Galactic absorption in u band (magnitudes) A_g, A_r, A_i, A_z = 0.736, 0.534, 0.405, 0.287 x A_u';
COMMENT ON COLUMN qsos.lgnh IS 'log [Galactic HI column density]';
COMMENT ON COLUMN qsos.firstmag IS 'FIRST Peak flux density (AB mag) at 20 cm  (AB mag = -2.5 log_10 [f_nu / 3631 Jy])     0.000 ==> no detection    -1.000 ==> not in FIRST survey area';
COMMENT ON COLUMN qsos.first_sn IS 'S/N ratio for FIRST flux';
COMMENT ON COLUMN qsos.first_sep IS 'SDSS/FIRST separation (arc seconds)';
COMMENT ON COLUMN qsos.lg_rass_rate IS 'log RASS BSC/FSC full band count rate (counts/second)     -9.000 ==> no detection          X-ray data from ROSAT All Sky Survey  Bright and Faint source catalogs';
COMMENT ON COLUMN qsos.rass_sn IS 'S/N ratio for RASS count rate';
COMMENT ON COLUMN qsos.rass_sep IS 'SDSS/RASS separation (arc seconds)';
COMMENT ON COLUMN qsos.twomassmag_j IS '2MASS J magnitude          All 2MASS data are from the 2MASS All-Sky Data Release  Point Source Catalog (PSC)   2003 March 25      0.000 ==> no detection';
COMMENT ON COLUMN qsos.twomassmagerr_j IS '2MASS J magnitude error                    ** Note that 2MASS measurements are Vega-based, not AB, magnitudes **';
COMMENT ON COLUMN qsos.twomassmag_h IS '2MASS H magnitude';
COMMENT ON COLUMN qsos.twomassmagerr_h IS '2MASS H magnitude error';
COMMENT ON COLUMN qsos.twomassmag_k IS '2MASS K magnitude';
COMMENT ON COLUMN qsos.twomassmagerr_k IS '2MASS K magnitude error';
COMMENT ON COLUMN qsos.twomass_sep IS 'SDSS/2MASS separation (arc seconds)';
COMMENT ON COLUMN qsos.twomass_flag IS '2MASS Flag = 9*JFLAG+3*HFLAG+KFLAG  Individual filter flags   0 = No Detection   1 = Catalog Match  2 = New Photometry on Images';
COMMENT ON COLUMN qsos.m_i IS 'M_i  (Absolute i magnitude for Ho:  70.0     Omega_M:   0.300     Omega_L:   0.700     alpha_Q: -0.50)';
COMMENT ON COLUMN qsos.delgi IS 'Delta(g-i)  Offset in magnitudes of the quasar (g-i) from the mode of the distribution of (g-i) of quasars at this redshift.  A value of -9.0 indicates too few quasars at redshift to form mean relation.  (All colors corrected for Galactic extinction)';
COMMENT ON COLUMN qsos.morphology IS 'Morphology flag            0 = point source      1 = extended';
COMMENT ON COLUMN qsos.scienceprimary IS 'SCIENCEPRIMARY flag        0 = Object is not SCIENCEPRIMARY       1 = Object is SCIENCEPRIMARY';
COMMENT ON COLUMN qsos.mode IS 'SDSS MODE flag (blends, overlapping scans)    1 = Primary object      2 = Secondary observation      3 = Family observation';
COMMENT ON COLUMN qsos.uniform IS 'Uniform target selection flag     (0 = not selected with final algorithm    1 = selected with final algorithm';
COMMENT ON COLUMN qsos.bestprimtarget IS 'Target selection flag (BEST)';
COMMENT ON COLUMN qsos.ts_b_lowz IS 'Low-z Quasar (color selection only) target flag           0 = not targeted as low-z quasar        1 = targeted as low-z quasar';
COMMENT ON COLUMN qsos.ts_b_hiz IS 'High-z Quasar (color selection only) target flag          0 = not targeted as high-z quasar       1 = targeted as high-z quasar';
COMMENT ON COLUMN qsos.ts_b_first IS 'FIRST target flag           0 = not targeted as FIRST        1 = targeted as FIRST';
COMMENT ON COLUMN qsos.ts_b_rosat IS 'ROSAT target flag           0 = not targeted as ROSAT        1 = targeted as ROSAT';
COMMENT ON COLUMN qsos.ts_b_serendip IS 'Serendipity target flag     0 = not targeted as serendipity  1 = targeted as serendipity';
COMMENT ON COLUMN qsos.ts_b_star IS 'Star target flag            0 = not targeted as star         1 = targeted as star';
COMMENT ON COLUMN qsos.ts_b_gal IS 'Galaxy target flag          0 = not targeted as galaxy       1 = targeted as galaxy';
COMMENT ON COLUMN qsos.run_best IS 'SDSS Imaging Run Number for photometric measurements';
COMMENT ON COLUMN qsos.mjd_best IS 'Modified Julian Date of imaging observation';
COMMENT ON COLUMN qsos.mjd IS 'Modified Julian Date of spectroscopic observation';
COMMENT ON COLUMN qsos.plate IS 'Spectroscopic Plate Number';
COMMENT ON COLUMN qsos.fiber IS 'Spectroscopic Fiber Number';
COMMENT ON COLUMN qsos.rerun_best IS 'SDSS Photometric Processing Rerun Number';
COMMENT ON COLUMN qsos.camcol_best IS 'SDSS Camera Column Number';
COMMENT ON COLUMN qsos.field_best IS 'SDSS Frame Number';
COMMENT ON COLUMN qsos.obj_best IS 'SDSS Object Number';
COMMENT ON COLUMN qsos.targprimtarget IS 'Target selection flag (TARGET)';
COMMENT ON COLUMN qsos.ts_t_lowz IS 'Low-z Quasar (color selection only) target flag           0 = not targeted as low-z quasar        1 = targeted as low-z quasar';
COMMENT ON COLUMN qsos.ts_t_hiz IS 'High-z Quasar (color selection only) target flag          0 = not targeted as high-z quasar       1 = targeted as high-z quasar';
COMMENT ON COLUMN qsos.ts_t_first IS 'FIRST target flag           0 = not targeted as FIRST        1 = targeted as FIRST';
COMMENT ON COLUMN qsos.ts_t_rosat IS 'ROSAT target flag           0 = not targeted as ROSAT        1 = targeted as ROSAT';
COMMENT ON COLUMN qsos.ts_t_serendip IS 'Serendipity target flag     0 = not targeted as serendipity  1 = targeted as serendipity';
COMMENT ON COLUMN qsos.ts_t_star IS 'Star target flag            0 = not targeted as star         1 = targeted as star';
COMMENT ON COLUMN qsos.ts_t_gal IS 'Galaxy target flag          0 = not targeted as galaxy       1 = targeted as galaxy';
COMMENT ON COLUMN qsos.t_psfmag_u IS 'u PSF magnitude (TARGET)    0.000 ==> cannot retrieve value from SDSS database';
COMMENT ON COLUMN qsos.t_psfmagerr_u IS 'error in u PSF magnitude (TARGET)';
COMMENT ON COLUMN qsos.t_psfmag_g IS 'g PSF magnitude (TARGET)';
COMMENT ON COLUMN qsos.t_psfmagerr_g IS 'error in g PSF magnitude (TARGET)';
COMMENT ON COLUMN qsos.t_psfmag_r IS 'r PSF magnitude (TARGET)';
COMMENT ON COLUMN qsos.t_psfmagerr_r IS 'error in r PSF magnitude (TARGET)';
COMMENT ON COLUMN qsos.t_psfmag_i IS 'i PSF magnitude (TARGET)';
COMMENT ON COLUMN qsos.t_psfmagerr_i IS 'error in i PSF magnitude (TARGET)';
COMMENT ON COLUMN qsos.t_psfmag_z IS 'z PSF magnitude (TARGET)';
COMMENT ON COLUMN qsos.t_psfmagerr_z IS 'error in z PSF magnitude (TARGET)';
COMMENT ON COLUMN qsos.objid IS 'BestObjID (64-bit integer)';
COMMENT ON COLUMN qsos.oldname_desig IS 'Object Name Prefix if previously published. (SDSS in this column indicates that the object is a previously published SDSS discovery)';
COMMENT ON COLUMN qsos.lon IS ' R.A. (degrees) -180 < longitude < +180';
COMMENT ON COLUMN qsos.lat IS 'declination (degrees)';
COMMENT ON COLUMN qsos.geopoint IS 'Binary representaion of lon/lat for spatial queries';
ALTER TABLE ONLY qsos
    ADD CONSTRAINT qsos_pkey PRIMARY KEY (specid);
CREATE INDEX idx_qsos_gist_geopoint ON qsos USING gist (geopoint);
CREATE INDEX idx_qsos_plate_fiber_mjd ON qsos USING btree (plate, fiber, mjd);
CREATE INDEX idx_qsos_redshift ON qsos USING btree (redshift);
REVOKE ALL ON TABLE qsos FROM PUBLIC;
GRANT ALL ON TABLE qsos TO sdss_dev;
GRANT SELECT ON TABLE qsos TO sdss;

DROP TABLE cat_qso;
CREATE TABLE cat_qso (
    qid integer DEFAULT 0 NOT NULL,
    plate integer,
    fiber integer,
    mjd integer,
    z_S10 double precision,
    z_best double precision,
    imag double precision,
    BAL_flag smallint,
    BAL_flag2 smallint,
    flux_first real,
    snr_first real,
    target_first smallint,
    sep_first real,
    iabMag real,
    z_fgal real,
    spec_aveSNR real,
    spec_medSNR real,
    spec_aveSNR_red real,
    spec_medSNR_red real,
    W_limit_1216_1241 real,
    W_limit_1241_1400 real,
    W_limit_1400_1549 real,
    W_limit_1549_1909 real,
    W_limit_1909_2799 real,
    W_limit_2799_3969 real,
    W_limit_3969_8200 real,
    specid bigint, -- fill in with join with schneider 2010 table
    agg_ab_sys character varying -- fill in with join from cata_sys table
);

COMMENT ON COLUMN cat_qso.qid IS 'QSO id (inremented for each qso)';
COMMENT ON COLUMN cat_qso.plate IS 'Spectroscopic Plate Number';
COMMENT ON COLUMN cat_qso.fiber IS 'Spectroscopic Fiber Number';
COMMENT ON COLUMN cat_qso.mjd IS 'Modified Julian Date of spectroscopic observation';
COMMENT ON COLUMN cat_qso.z_S10 IS 'Emission redshift of the QSO from Schneider et al. 2010 DR7 QSO Catalog';
COMMENT ON COLUMN cat_qso.z_best IS 'Best determined emission redshift, used by the pipeline (from Hewett & Wild 2010, if available)';
COMMENT ON COLUMN cat_qso.BAL_flag IS 'Broad Absorption Line System QSO flag. 0 = not identified as a BALQSO 1 = BAL identified in DR5 Gibson et al. catalog 10 = BAL verified by DVB, in post-DR5 catalog 20 = BAL candidate inspected by DVB but of ambiguous classification, in post-DR5 catalog';
COMMENT ON COLUMN cat_qso.BAL_flag2 IS 'Broad Absorption Line System QSO flag from Shen et al. DR7 BAL Catalog 0 = not identified as a BALQSO 1 = BAL identified in DR5 Gibson et al. catalog  2 = BAL candidate identified by Shen only  3 = BAL identified by Wesolowski only  4 = BAL candidate identified by both Shen and Wesolowski';
COMMENT ON COLUMN cat_qso.flux_first IS '20cm radio flux from FIRST (Schneider et al. 2010)';
COMMENT ON COLUMN cat_qso.snr_first IS '20cm radio flux signal-to-noise from FIRST (Schneider et al. 2010)';
COMMENT ON COLUMN cat_qso.target_first IS 'SDSS FIRST target flag (Schneider et al. 2010)';
COMMENT ON COLUMN cat_qso.sep_first IS 'Angular separation of SDSS/FIRST sources (arcsec) (Schneider et al. 2010)';
COMMENT ON COLUMN cat_qso.iabMag IS 'Absolute magnitude in the i-band (Schneider et al. 2010)';
COMMENT ON COLUMN cat_qso.z_fgal IS 'Redshift of identified foreground galaxy';
COMMENT ON COLUMN cat_qso.spec_aveSNR IS 'Mean per-pixel SNR of the spectrum at lambda>1250 Angstroms in the quasar rest frame';
COMMENT ON COLUMN cat_qso.spec_medSNR IS 'Median per-pixel SNR of the spectrum at lambda>1250 Angstroms in the quasar rest frame';
COMMENT ON COLUMN cat_qso.spec_aveSNR_red IS 'Mean per-pixel SNR of the spectrum at lambda>7200 Angstroms in the observed frame';
COMMENT ON COLUMN cat_qso.spec_medSNR_red IS '  Median per-pixel SNR of the spectrum at lambda>7200 Angstroms in the observed frame';
COMMENT ON COLUMN cat_qso.W_limit_1216_1241 IS 'W limit (median two pixel 1-sigma error) between restframe [1215.7-1240.81';
COMMENT ON COLUMN cat_qso.W_limit_1241_1400 IS 'W limit (median two pixel 1-sigma error) between restframe [1240.81-1399.8]';
COMMENT ON COLUMN cat_qso.W_limit_1400_1549 IS 'W limit (median two pixel 1-sigma error) between restframe [1399.8-1549.48]';
COMMENT ON COLUMN cat_qso.W_limit_1549_1909 IS 'W limit (median two pixel 1-sigma error) between restframe [1549.48-1908.73]';
COMMENT ON COLUMN cat_qso.W_limit_1909_2799 IS 'W limit (median two pixel 1-sigma error) between restframe [1908.73-2799.117]';
COMMENT ON COLUMN cat_qso.W_limit_2799_3969 IS 'W limit (median two pixel 1-sigma error) between restframe [2799.117-3969.0]';
COMMENT ON COLUMN cat_qso.W_limit_3969_8200 IS 'W limit (median two pixel 1-sigma error) between restframe [3969.0-8200.0]';

ALTER TABLE public.cat_qso OWNER TO sdss_dev;
ALTER TABLE ONLY cat_qso
    ADD CONSTRAINT dr7_cat_qso_pkey PRIMARY KEY (qid);
CREATE UNIQUE INDEX cat_qso_specid ON cat_qso USING btree (specid);
REVOKE ALL ON TABLE cat_qso FROM PUBLIC;
GRANT ALL ON TABLE cat_qso TO sdss_dev;
GRANT SELECT ON TABLE cat_qso TO sdss;

DROP TABLE cat_sys;
CREATE TABLE cat_sys (
    qid integer,
    sid integer DEFAULT 0 NOT NULL,
    zab double precision,
    lam_low numeric(6,2) DEFAULT NULL::numeric,
    lam_high numeric(6,2) DEFAULT NULL::numeric,
    grade character varying(10) DEFAULT NULL::character varying,
    type character varying(6) DEFAULT NULL::character varying,
    beta double precision
);


ALTER TABLE public.cat_sys OWNER TO sdss_dev;
COMMENT ON COLUMN cat_sys.qid IS 'QSO id (inremented for each qso)';
COMMENT ON COLUMN cat_sys.lam_low IS 'Lower wavelength limit of the SDSS spectrograph in Angstroms in the absorber rest frame';
COMMENT ON COLUMN cat_sys.lam_high IS 'Upper wavelength limit of the SDSS spectrograph in Angstroms in the absorber rest frame';
COMMENT ON COLUMN cat_sys.grade IS 'Confidence grade assigned to the absorption system';
COMMENT ON COLUMN cat_sys.type IS 'Selection method for identifying system - some combination of M;C; and F';
COMMENT ON COLUMN cat_sys.beta IS 'Velocity (v/c) of the absorber in the QSO rest-frame; calculated using Hewett & Wild 2010 redshifts';
ALTER TABLE ONLY cat_sys
    ADD CONSTRAINT dr7_cat_sys_pkey PRIMARY KEY (sid);
REVOKE ALL ON TABLE cat_sys FROM PUBLIC;
GRANT ALL ON TABLE cat_sys TO sdss_dev;
GRANT SELECT ON TABLE cat_sys TO sdss;

DROP TABLE cat_line;
CREATE TABLE cat_line (
    qid integer,
    sid integer,
    lid integer DEFAULT 0 NOT NULL,
    obs_lam numeric(6,2) DEFAULT NULL::numeric,
    w_obs numeric(8,3) DEFAULT NULL::numeric,
    w_obserr numeric(6,3) DEFAULT NULL::numeric,
    ion_lam numeric(6,1) DEFAULT NULL::numeric,
    ion_name character varying(12) DEFAULT NULL::character varying,
    ly_a integer,
    deltaz double precision,
    deltav double precision,
    snr numeric(4,1) DEFAULT NULL::numeric,
    fwhm numeric(5,2) DEFAULT NULL::numeric
);


ALTER TABLE public.cat_line OWNER TO sdss_dev;
COMMENT ON COLUMN cat_line.qid IS 'QSO id (inremented for each qso)';
COMMENT ON COLUMN cat_line.sid IS 'System id (incremented for each system)';
COMMENT ON COLUMN cat_line.lid IS 'Absorption line number';
COMMENT ON COLUMN cat_line.obs_lam IS 'Observed Wavelength: observed wavelength of the absorption line in Angstroms';
COMMENT ON COLUMN cat_line.w_obs IS 'Observer-frame equivalent width in Angstroms as determined by fitting a Gaussian profile to the absorption line';
COMMENT ON COLUMN cat_line.w_obserr IS '1-sigma error (in Angstroms) on the observer-frame equivalent width';
COMMENT ON COLUMN cat_line.ion_lam IS 'Laboratory wavelength of transition (Angstroms)';
COMMENT ON COLUMN cat_line.ion_name IS 'Name of species (e.g. Mg)';
COMMENT ON COLUMN cat_line.ly_a IS 'Flag indicating whether the line is shortward (1) or longward (0) of the Ly-a emission line';
COMMENT ON COLUMN cat_line.deltaz IS 'Difference between the redshift of this particular line and the average redshift of the system into which it has been placed (z_line - z_avg)';
COMMENT ON COLUMN cat_line.deltav IS 'Velocity difference; determined from deltaz';
COMMENT ON COLUMN cat_line.snr IS 'Significance of the line in standard deviations from the error (i.e.; W_obs / W_obs_err)';
COMMENT ON COLUMN cat_line.fwhm IS 'FWHM of the line (pixels)';

ALTER TABLE ONLY cat_line
    ADD CONSTRAINT dr7_cat_line_pkey PRIMARY KEY (lid);
REVOKE ALL ON TABLE cat_line FROM PUBLIC;
GRANT ALL ON TABLE cat_line TO sdss_dev;
GRANT SELECT ON TABLE cat_line TO sdss;

DROP TABLE cat_join_all_mv;
CREATE TABLE cat_join_all_mv (
    specid bigint,
    sdssname character varying(64),
    ra double precision,
    decl double precision,
    redshift real,
    psfmag_u real,
    psfmagerr_u real,
    psfmag_g real,
    psfmagerr_g real,
    psfmag_r real,
    psfmagerr_r real,
    psfmag_i real,
    psfmagerr_i real,
    psfmag_z real,
    psfmagerr_z real,
    a_u real,
    lgnh real,
    firstmag real,
    first_sn real,
    first_sep real,
    lg_rass_rate real,
    rass_sn real,
    rass_sep real,
    twomassmag_j real,
    twomassmagerr_j real,
    twomassmag_h real,
    twomassmagerr_h real,
    twomassmag_k real,
    twomassmagerr_k real,
    twomass_sep real,
    twomass_flag bigint,
    m_i real,
    delgi real,
    morphology smallint,
    scienceprimary smallint,
    mode smallint,
    uniform smallint,
    bestprimtarget bigint,
    ts_b_lowz smallint,
    ts_b_hiz smallint,
    ts_b_first smallint,
    ts_b_rosat smallint,
    ts_b_serendip smallint,
    ts_b_star smallint,
    ts_b_gal smallint,
    run_best integer,
    mjd_best integer,
    mjd integer,
    plate integer,
    fiber integer,
    rerun_best integer,
    camcol_best integer,
    field_best integer,
    obj_best integer,
    targprimtarget bigint,
    ts_t_lowz smallint,
    ts_t_hiz smallint,
    ts_t_first smallint,
    ts_t_rosat smallint,
    ts_t_serendip smallint,
    ts_t_star smallint,
    ts_t_gal smallint,
    t_psfmag_u real,
    t_psfmagerr_u real,
    t_psfmag_g real,
    t_psfmagerr_g real,
    t_psfmag_r real,
    t_psfmagerr_r real,
    t_psfmag_i real,
    t_psfmagerr_i real,
    t_psfmag_z real,
    t_psfmagerr_z real,
    objid bigint,
    oldname_type character varying(24),
    oldname_desig character varying(24),
    lon double precision,
    lat double precision,
    geopoint geography,
    qid integer,
    qso_z_best double precision,
    qso_imag double precision,
    qso_BAL_flag smallint,
    qso_BAL_flag2 smallint,
    qso_z_fgal real,
    qso_spec_aveSNR real,
    qso_spec_medSNR real,
    qso_spec_aveSNR_red real,
    qso_spec_medSNR_red real,
    qso_W_limit_1216_1241 real,
    qso_W_limit_1241_1400 real,
    qso_W_limit_1400_1549 real,
    qso_W_limit_1549_1909 real,
    qso_W_limit_1909_2799 real,
    qso_W_limit_2799_3969 real,
    qso_W_limit_3969_8200 real,
    sid integer,
    sys_zab real,
    sys_lam_low numeric(6,2),
    sys_lam_high numeric(6,2),
    sys_grade character varying(10),
    sys_type character varying(6),
    sys_beta double precision,
    lid integer,
    line_obs_lam numeric(6,2),
    line_w_obs numeric(8,3),
    line_w_obserr numeric(6,3),
    line_w_rest double precision,
    line_w_resterr double precision,
    line_ion_lam numeric(6,1),
    line_ion_name character varying(12),
    line_ly_a integer,
    line_deltaz double precision,
    line_deltav double precision,
    line_snr numeric(4,1),
    line_fwhm numeric(5,2),
    qso_agg_ab_sys character varying
);


ALTER TABLE public.cat_join_all_mv OWNER TO sdss_dev;
COMMENT ON COLUMN cat_join_all_mv.specid IS 'Spectrocopic id (primary key)';
COMMENT ON COLUMN cat_join_all_mv.sdssname IS 'DR7 Object Designation   hhmmss.ss+ddmmss.s  (J2000; truncated coordinates)';
COMMENT ON COLUMN cat_join_all_mv.ra IS 'R.A.(J2000) in degrees';
COMMENT ON COLUMN cat_join_all_mv.decl IS 'Dec.(J2000) in degrees';
COMMENT ON COLUMN cat_join_all_mv.redshift IS 'Redshift';
COMMENT ON COLUMN cat_join_all_mv.psfmag_u IS 'u PSF magnitude';
COMMENT ON COLUMN cat_join_all_mv.psfmagerr_u IS 'error in u PSF magnitude';
COMMENT ON COLUMN cat_join_all_mv.psfmag_g IS 'g PSF magnitude';
COMMENT ON COLUMN cat_join_all_mv.psfmagerr_g IS 'g PSF magnitude error';
COMMENT ON COLUMN cat_join_all_mv.psfmag_r IS 'r PSF magnitude';
COMMENT ON COLUMN cat_join_all_mv.psfmagerr_r IS 'r PSF magnitude error';
COMMENT ON COLUMN cat_join_all_mv.psfmag_i IS 'i PSF magnitude';
COMMENT ON COLUMN cat_join_all_mv.psfmagerr_i IS 'i PSF magnitude error';
COMMENT ON COLUMN cat_join_all_mv.psfmag_z IS 'z PSF magnitude';
COMMENT ON COLUMN cat_join_all_mv.psfmagerr_z IS 'z PSF magnitude error';
COMMENT ON COLUMN cat_join_all_mv.a_u IS 'Galactic absorption in u band (magnitudes) A_g, A_r, A_i, A_z = 0.736, 0.534, 0.405, 0.287 x A_u';
COMMENT ON COLUMN cat_join_all_mv.lgnh IS 'log [Galactic HI column density]';
COMMENT ON COLUMN cat_join_all_mv.firstmag IS 'FIRST Peak flux density (AB mag) at 20 cm  (AB mag = -2.5 log_10 [f_nu / 3631 Jy])     0.000 ==> no detection    -1.000 ==> not in FIRST survey area';
COMMENT ON COLUMN cat_join_all_mv.first_sn IS 'S/N ratio for FIRST flux';
COMMENT ON COLUMN cat_join_all_mv.first_sep IS 'SDSS/FIRST separation (arc seconds)';
COMMENT ON COLUMN cat_join_all_mv.lg_rass_rate IS 'log RASS BSC/FSC full band count rate (counts/second)     -9.000 ==> no detection          X-ray data from ROSAT All Sky Survey  Bright and Faint source catalogs';
COMMENT ON COLUMN cat_join_all_mv.rass_sn IS 'S/N ratio for RASS count rate';
COMMENT ON COLUMN cat_join_all_mv.rass_sep IS 'SDSS/RASS separation (arc seconds)';
COMMENT ON COLUMN cat_join_all_mv.twomassmag_j IS '2MASS J magnitude          All 2MASS data are from the 2MASS All-Sky Data Release  Point Source Catalog (PSC)   2003 March 25      0.000 ==> no detection';
COMMENT ON COLUMN cat_join_all_mv.twomassmagerr_j IS '2MASS J magnitude error                    ** Note that 2MASS measurements are Vega-based, not AB, magnitudes **';
COMMENT ON COLUMN cat_join_all_mv.twomassmag_h IS '2MASS H magnitude';
COMMENT ON COLUMN cat_join_all_mv.twomassmagerr_h IS '2MASS H magnitude error';
COMMENT ON COLUMN cat_join_all_mv.twomassmag_k IS '2MASS K magnitude';
COMMENT ON COLUMN cat_join_all_mv.twomassmagerr_k IS '2MASS K magnitude error';
COMMENT ON COLUMN cat_join_all_mv.twomass_sep IS 'SDSS/2MASS separation (arc seconds)';
COMMENT ON COLUMN cat_join_all_mv.twomass_flag IS '2MASS Flag = 9*JFLAG+3*HFLAG+KFLAG  Individual filter flags   0 = No Detection   1 = Catalog Match  2 = New Photometry on Images';
COMMENT ON COLUMN cat_join_all_mv.m_i IS 'M_i  (Absolute i magnitude for Ho:  70.0     Omega_M:   0.300     Omega_L:   0.700     alpha_Q: -0.50)';
COMMENT ON COLUMN cat_join_all_mv.delgi IS 'Delta(g-i)  Offset in magnitudes of the quasar (g-i) from the mode of the distribution of (g-i) of quasars at this redshift.  A value of -9.0 indicates too few quasars at redshift to form mean relation.  (All colors corrected for Galactic extinction)';
COMMENT ON COLUMN cat_join_all_mv.morphology IS 'Morphology flag            0 = point source      1 = extended';
COMMENT ON COLUMN cat_join_all_mv.scienceprimary IS 'SCIENCEPRIMARY flag        0 = Object is not SCIENCEPRIMARY       1 = Object is SCIENCEPRIMARY';
COMMENT ON COLUMN cat_join_all_mv.mode IS 'SDSS MODE flag (blends, overlapping scans)    1 = Primary object      2 = Secondary observation      3 = Family observation';
COMMENT ON COLUMN cat_join_all_mv.uniform IS 'Uniform target selection flag     (0 = not selected with final algorithm    1 = selected with final algorithm';
COMMENT ON COLUMN cat_join_all_mv.bestprimtarget IS 'Target selection flag (BEST)';
COMMENT ON COLUMN cat_join_all_mv.ts_b_lowz IS 'Low-z Quasar (color selection only) target flag           0 = not targeted as low-z quasar        1 = targeted as low-z quasar';
COMMENT ON COLUMN cat_join_all_mv.ts_b_hiz IS 'High-z Quasar (color selection only) target flag          0 = not targeted as high-z quasar       1 = targeted as high-z quasar';
COMMENT ON COLUMN cat_join_all_mv.ts_b_first IS 'FIRST target flag           0 = not targeted as FIRST        1 = targeted as FIRST';
COMMENT ON COLUMN cat_join_all_mv.ts_b_rosat IS 'ROSAT target flag           0 = not targeted as ROSAT        1 = targeted as ROSAT';
COMMENT ON COLUMN cat_join_all_mv.ts_b_serendip IS 'Serendipity target flag     0 = not targeted as serendipity  1 = targeted as serendipity';
COMMENT ON COLUMN cat_join_all_mv.ts_b_star IS 'Star target flag            0 = not targeted as star         1 = targeted as star';
COMMENT ON COLUMN cat_join_all_mv.ts_b_gal IS 'Galaxy target flag          0 = not targeted as galaxy       1 = targeted as galaxy';
COMMENT ON COLUMN cat_join_all_mv.run_best IS 'SDSS Imaging Run Number for photometric measurements';
COMMENT ON COLUMN cat_join_all_mv.mjd_best IS 'Modified Julian Date of imaging observation';
COMMENT ON COLUMN cat_join_all_mv.mjd IS 'Modified Julian Date of spectroscopic observation';
COMMENT ON COLUMN cat_join_all_mv.plate IS 'Spectroscopic Plate Number';
COMMENT ON COLUMN cat_join_all_mv.fiber IS 'Spectroscopic Fiber Number';
COMMENT ON COLUMN cat_join_all_mv.rerun_best IS 'SDSS Photometric Processing Rerun Number';
COMMENT ON COLUMN cat_join_all_mv.camcol_best IS 'SDSS Camera Column Number';
COMMENT ON COLUMN cat_join_all_mv.field_best IS 'SDSS Frame Number';
COMMENT ON COLUMN cat_join_all_mv.obj_best IS 'SDSS Object Number';
COMMENT ON COLUMN cat_join_all_mv.targprimtarget IS 'Target selection flag (TARGET)';
COMMENT ON COLUMN cat_join_all_mv.ts_t_lowz IS 'Low-z Quasar (color selection only) target flag           0 = not targeted as low-z quasar        1 = targeted as low-z quasar';
COMMENT ON COLUMN cat_join_all_mv.ts_t_hiz IS 'High-z Quasar (color selection only) target flag          0 = not targeted as high-z quasar       1 = targeted as high-z quasar';
COMMENT ON COLUMN cat_join_all_mv.ts_t_first IS 'FIRST target flag           0 = not targeted as FIRST        1 = targeted as FIRST';
COMMENT ON COLUMN cat_join_all_mv.ts_t_rosat IS 'ROSAT target flag           0 = not targeted as ROSAT        1 = targeted as ROSAT';
COMMENT ON COLUMN cat_join_all_mv.ts_t_serendip IS 'Serendipity target flag     0 = not targeted as serendipity  1 = targeted as serendipity';
COMMENT ON COLUMN cat_join_all_mv.ts_t_star IS 'Star target flag            0 = not targeted as star         1 = targeted as star';
COMMENT ON COLUMN cat_join_all_mv.ts_t_gal IS 'Galaxy target flag          0 = not targeted as galaxy       1 = targeted as galaxy';
COMMENT ON COLUMN cat_join_all_mv.t_psfmag_u IS 'u PSF magnitude (TARGET)    0.000 ==> cannot retrieve value from SDSS database';
COMMENT ON COLUMN cat_join_all_mv.t_psfmagerr_u IS 'error in u PSF magnitude (TARGET)';
COMMENT ON COLUMN cat_join_all_mv.t_psfmag_g IS 'g PSF magnitude (TARGET)';
COMMENT ON COLUMN cat_join_all_mv.t_psfmagerr_g IS 'error in g PSF magnitude (TARGET)';
COMMENT ON COLUMN cat_join_all_mv.t_psfmag_r IS 'r PSF magnitude (TARGET)';
COMMENT ON COLUMN cat_join_all_mv.t_psfmagerr_r IS 'error in r PSF magnitude (TARGET)';
COMMENT ON COLUMN cat_join_all_mv.t_psfmag_i IS 'i PSF magnitude (TARGET)';
COMMENT ON COLUMN cat_join_all_mv.t_psfmagerr_i IS 'error in i PSF magnitude (TARGET)';
COMMENT ON COLUMN cat_join_all_mv.t_psfmag_z IS 'z PSF magnitude (TARGET)';
COMMENT ON COLUMN cat_join_all_mv.t_psfmagerr_z IS 'error in z PSF magnitude (TARGET)';
COMMENT ON COLUMN cat_join_all_mv.objid IS 'BestObjID (64-bit integer)';
COMMENT ON COLUMN cat_join_all_mv.oldname_type IS 'Object Name Prefix if previously published. (SDSS in this column indicates that the object is a previously published SDSS discovery)';
COMMENT ON COLUMN cat_join_all_mv.oldname_desig IS 'Object Name if previously published.';
COMMENT ON COLUMN cat_join_all_mv.lon IS ' R.A. (degrees) -180 < longitude < +180';
COMMENT ON COLUMN cat_join_all_mv.lat IS 'declination (degrees)';
COMMENT ON COLUMN cat_join_all_mv.geopoint IS 'Binary representaion of lon/lat for spatial queries';
COMMENT ON COLUMN cat_join_all_mv.qso_z_best IS 'Best determined emission redshift, used by the pipeline (from Hewett & Wild 2010, if available)';
COMMENT ON COLUMN cat_join_all_mv.qso_BAL_flag IS 'Broad Absorption Line System QSO flag. 0 = not identified as a BALQSO 1 = BAL identified in DR5 Gibson et al. catalog 10 = BAL verified by DVB, in post-DR5 catalog 20 = BAL candidate inspected by DVB but of ambiguous classification, in post-DR5 catalog';
COMMENT ON COLUMN cat_join_all_mv.qso_BAL_flag2 IS 'Broad Absorption Line System QSO flag from Shen et al. DR7 BAL Catalog 0 = not identified as a BALQSO 1 = BAL identified in DR5 Gibson et al. catalog  2 = BAL candidate identified by Shen only  3 = BAL identified by Wesolowski only  4 = BAL candidate identified by both Shen and Wesolowski';
COMMENT ON COLUMN cat_join_all_mv.qso_flux_first IS '20cm radio flux from FIRST (Schneider et al. 2010)';
COMMENT ON COLUMN cat_join_all_mv.qso_snr_first IS '20cm radio flux signal-to-noise from FIRST (Schneider et al. 2010)';
COMMENT ON COLUMN cat_join_all_mv.qso_target_first IS 'SDSS FIRST target flag (Schneider et al. 2010)';
COMMENT ON COLUMN cat_join_all_mv.qso_sep_first IS 'Angular separation of SDSS/FIRST sources (arcsec) (Schneider et al. 2010)';
COMMENT ON COLUMN cat_join_all_mv.qso_iabMag IS 'Absolute magnitude in the i-band (Schneider et al. 2010)';
COMMENT ON COLUMN cat_join_all_mv.qso_z_fgal IS 'Redshift of identified foreground galaxy';
COMMENT ON COLUMN cat_join_all_mv.qso_spec_aveSNR IS 'Mean per-pixel SNR of the spectrum at lambda>1250 Angstroms in the quasar rest frame';
COMMENT ON COLUMN cat_join_all_mv.qso_spec_medSNR IS 'Median per-pixel SNR of the spectrum at lambda>1250 Angstroms in the quasar rest frame';
COMMENT ON COLUMN cat_join_all_mv.qso_spec_aveSNR_red IS 'Mean per-pixel SNR of the spectrum at lambda>7200 Angstroms in the observed frame';
COMMENT ON COLUMN cat_join_all_mv.qso_spec_medSNR_red IS '  Median per-pixel SNR of the spectrum at lambda>7200 Angstroms in the observed frame';
COMMENT ON COLUMN cat_join_all_mv.qso_W_limit_1216_1241 IS 'W limit (median two pixel 1-sigma error) between restframe [1215.7-1240.81';
COMMENT ON COLUMN cat_join_all_mv.qso_W_limit_1241_1400 IS 'W limit (median two pixel 1-sigma error) between restframe [1240.81-1399.8]';
COMMENT ON COLUMN cat_join_all_mv.qso_W_limit_1400_1549 IS 'W limit (median two pixel 1-sigma error) between restframe [1399.8-1549.48]';
COMMENT ON COLUMN cat_join_all_mv.qso_W_limit_1549_1909 IS 'W limit (median two pixel 1-sigma error) between restframe [1549.48-1908.73]';
COMMENT ON COLUMN cat_join_all_mv.qso_W_limit_1909_2799 IS 'W limit (median two pixel 1-sigma error) between restframe [1908.73-2799.117]';
COMMENT ON COLUMN cat_join_all_mv.qso_W_limit_2799_3969 IS 'W limit (median two pixel 1-sigma error) between restframe [2799.117-3969.0]';
COMMENT ON COLUMN cat_join_all_mv.qso_W_limit_3969_8200 IS 'W limit (median two pixel 1-sigma error) between restframe [3969.0-8200.0]';
COMMENT ON COLUMN cat_join_all_mv.sid IS 'system id (incremented for each system)';
COMMENT ON COLUMN cat_join_all_mv.sys_lam_low IS 'Lower wavelength limit of the SDSS spectrograph in Angstroms in the absorber rest frame';
COMMENT ON COLUMN cat_join_all_mv.sys_lam_high IS 'Upper wavelength limit of the SDSS spectrograph in Angstroms in the absorber rest frame';
COMMENT ON COLUMN cat_join_all_mv.sys_grade IS 'Confidence grade assigned to the absorption system';
COMMENT ON COLUMN cat_join_all_mv.sys_type IS 'Selection method for identifying system - some combination of M;C; and F';
COMMENT ON COLUMN cat_join_all_mv.sys_beta IS 'Velocity (v/c) of the absorber in the QSO rest-frame; calculated using Hewett & Wild 2010 redshifts';
COMMENT ON COLUMN cat_join_all_mv.lid IS 'Absorption line number';
COMMENT ON COLUMN cat_join_all_mv.line_obs_lam IS 'Observed Wavelength: observed wavelength of the absorption line in Angstroms';
COMMENT ON COLUMN cat_join_all_mv.line_w_obs IS 'Observer-frame equivalent width in Angstroms as determined by fitting a Gaussian profile to the absorption line';
COMMENT ON COLUMN cat_join_all_mv.line_w_obserr IS '1-sigma error (in Angstroms) on the observer-frame equivalent width';
COMMENT ON COLUMN cat_join_all_mv.line_w_rest IS 'Rest-frame equivalent width in Angstroms';
COMMENT ON COLUMN cat_join_all_mv.line_w_resterr IS '1-sigma error (in Angstroms) rest-frame equivalent width';
COMMENT ON COLUMN cat_join_all_mv.line_ion_lam IS 'Laboratory wavelength of transition (Angstroms)';
COMMENT ON COLUMN cat_join_all_mv.line_ion_name IS 'Name of species (e.g. Mg)';
COMMENT ON COLUMN cat_join_all_mv.line_ly_a IS 'Flag indicating whether the line is shortward (1) or longward (0) of the Ly-a emission line';
COMMENT ON COLUMN cat_join_all_mv.line_deltaz IS 'Difference between the redshift of this particular line and the average redshift of the system into which it has been placed (z_line - z_avg)';
COMMENT ON COLUMN cat_join_all_mv.line_deltav IS 'Velocity difference; determined from deltaz';
COMMENT ON COLUMN cat_join_all_mv.line_snr IS 'Significance of the line in standard deviations from the error (i.e.; W_obs / W_obs_err)';
COMMENT ON COLUMN cat_join_all_mv.line_fwhm IS 'FWHM of the line (pixels)';



CREATE INDEX idx_mv_grade ON cat_join_all_mv USING btree (sys_grade);
REVOKE ALL ON TABLE cat_join_all_mv FROM PUBLIC;
GRANT ALL ON TABLE cat_join_all_mv TO sdss_dev;
GRANT SELECT ON TABLE cat_join_all_mv TO sdss;

DROP TABLE cat_join_sys_mv;
CREATE TABLE cat_join_sys_mv (
    specid bigint,
    sdssname character varying(64),
    ra double precision,
    decl double precision,
    redshift real,
    psfmag_u real,
    psfmagerr_u real,
    psfmag_g real,
    psfmagerr_g real,
    psfmag_r real,
    psfmagerr_r real,
    psfmag_i real,
    psfmagerr_i real,
    psfmag_z real,
    psfmagerr_z real,
    a_u real,
    lgnh real,
    firstmag real,
    first_sn real,
    first_sep real,
    lg_rass_rate real,
    rass_sn real,
    rass_sep real,
    twomassmag_j real,
    twomassmagerr_j real,
    twomassmag_h real,
    twomassmagerr_h real,
    twomassmag_k real,
    twomassmagerr_k real,
    twomass_sep real,
    twomass_flag bigint,
    m_i real,
    delgi real,
    morphology smallint,
    scienceprimary smallint,
    mode smallint,
    uniform smallint,
    bestprimtarget bigint,
    ts_b_lowz smallint,
    ts_b_hiz smallint,
    ts_b_first smallint,
    ts_b_rosat smallint,
    ts_b_serendip smallint,
    ts_b_star smallint,
    ts_b_gal smallint,
    run_best integer,
    mjd_best integer,
    mjd integer,
    plate integer,
    fiber integer,
    rerun_best integer,
    camcol_best integer,
    field_best integer,
    obj_best integer,
    targprimtarget bigint,
    ts_t_lowz smallint,
    ts_t_hiz smallint,
    ts_t_first smallint,
    ts_t_rosat smallint,
    ts_t_serendip smallint,
    ts_t_star smallint,
    ts_t_gal smallint,
    t_psfmag_u real,
    t_psfmagerr_u real,
    t_psfmag_g real,
    t_psfmagerr_g real,
    t_psfmag_r real,
    t_psfmagerr_r real,
    t_psfmag_i real,
    t_psfmagerr_i real,
    t_psfmag_z real,
    t_psfmagerr_z real,
    objid bigint,
    oldname_type character varying(24),
    oldname_desig character varying(24),
    lon double precision,
    lat double precision,
    geopoint geography,
    qid integer,
    qso_z_best double precision,
    qso_imag double precision,
    qso_BAL_flag smallint,
    qso_BAL_flag2 smallint,
    qso_z_fgal real,
    qso_spec_aveSNR real,
    qso_spec_medSNR real,
    qso_spec_aveSNR_red real,
    qso_spec_medSNR_red real,
    qso_W_limit_1216_1241 real,
    qso_W_limit_1241_1400 real,
    qso_W_limit_1400_1549 real,
    qso_W_limit_1549_1909 real,
    qso_W_limit_1909_2799 real,
    qso_W_limit_2799_3969 real,
    qso_W_limit_3969_8200 real,
    sid integer NOT NULL,
    sys_zab real, 
    sys_lam_low numeric(6,2),
    sys_lam_high numeric(6,2),
    sys_grade character varying(10),
    sys_type character varying(6),
    sys_beta double precision,
    arr_lid integer[],
    agg_lid integer[],
    agg_line_obs_lam numeric[],
    agg_line_w_obs numeric[],
    agg_line_w_obserr numeric[],
    agg_line_w_rest double precision[],
    agg_line_w_resterr double precision[],
    agg_line_ion_lam numeric[],
    agg_line_ion_name character varying[],
    agg_line_ly_a integer[],
    agg_line_deltaz double precision[],
    agg_line_deltav double precision[],
    agg_line_snr numeric[],
    agg_line_fwhm numeric[]
);


ALTER TABLE public.cat_join_sys_mv OWNER TO sdss_dev;
COMMENT ON COLUMN cat_join_sys_mv.geopoint IS 'Binary representation of lon/lat for spatial queries';
ALTER TABLE ONLY cat_join_sys_mv
    ADD CONSTRAINT cat_join_sys_mv_pkey PRIMARY KEY (sid);
REVOKE ALL ON TABLE cat_join_sys_mv FROM PUBLIC;
GRANT ALL ON TABLE cat_join_sys_mv TO sdss_dev;
GRANT SELECT ON TABLE cat_join_sys_mv TO sdss;






