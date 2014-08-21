\copy cat_qso FROM './dbOutputTables/qsos.txt' WITH DELIMITER ',' NULL AS E'\\N'
\copy cat_sys FROM './dbOutputTables/systems.txt' WITH DELIMITER ',' NULL AS E'\\N'
\copy cat_line FROM './dbOutputTables/lines.txt' WITH DELIMITER ',' NULL AS E'\\N'
\copy qsos FROM '/var/www/html/sdssdr7pub/data/qsos.txt' WITH CSV HEADER DELIMITER E'\t' NULL AS E'\\N'
\copy column_alias FROM './column2Name.dat' WITH  DELIMITER ',' NULL AS E'\\N'

UPDATE cat_qso q
SET agg_ab_sys = agg_z
FROM
(SELECT qid, array_agg(sid) agg_sid, array_agg(zab) agg_z
from cat_sys
where grade
in ('A', 'B')
group by qid
) absys
WHERE q.qid = absys.qid;

UPDATE cat_qso SET agg_ab_sys=REPLACE(REPLACE(agg_ab_sys, '{',''),'}','');

UPDATE cat_qso
SET  specid = qsos.specid
FROM qsos
WHERE
cat_qso.plate = qsos.plate
AND cat_qso.fiber = qsos.fiber
AND cat_qso.mjd = qsos.mjd;


INSERT INTO cat_join_all_mv
SELECT qsos.specid,
qsos.sdssname,
qsos.ra,
qsos.decl,
qsos.redshift,
qsos.psfmag_u,
qsos.psfmagerr_u,
qsos.psfmag_g,
qsos.psfmagerr_g,
qsos.psfmag_r,
qsos.psfmagerr_r,
qsos.psfmag_i,
qsos.psfmagerr_i,
qsos.psfmag_z,
qsos.psfmagerr_z,
qsos.a_u,
qsos.lgnh,
qsos.firstmag,
qsos.first_sn,
qsos.first_sep,
qsos.lg_rass_rate,
qsos.rass_sn,
qsos.rass_sep,
qsos.twomassmag_j,
qsos.twomassmagerr_j,
qsos.twomassmag_h,
qsos.twomassmagerr_h,
qsos.twomassmag_k,
qsos.twomassmagerr_k,
qsos.twomass_sep,
qsos.twomass_flag,
qsos.m_i,
qsos.delgi,
qsos.morphology,
qsos.scienceprimary,
qsos.mode,
qsos.uniform,
qsos.bestprimtarget,
qsos.ts_b_lowz,
qsos.ts_b_hiz,
qsos.ts_b_first,
qsos.ts_b_rosat,
qsos.ts_b_serendip,
qsos.ts_b_star,
qsos.ts_b_gal,
qsos.run_best,
qsos.mjd_best,
qsos.mjd,
qsos.plate,
qsos.fiber,
qsos.rerun_best,
qsos.camcol_best,
qsos.field_best,
qsos.obj_best,
qsos.targprimtarget,
qsos.ts_t_lowz,
qsos.ts_t_hiz,
qsos.ts_t_first,
qsos.ts_t_rosat,
qsos.ts_t_serendip,
qsos.ts_t_star,
qsos.ts_t_gal,
qsos.t_psfmag_u,
qsos.t_psfmagerr_u,
qsos.t_psfmag_g,
qsos.t_psfmagerr_g,
qsos.t_psfmag_r,
qsos.t_psfmagerr_r,
qsos.t_psfmag_i,
qsos.t_psfmagerr_i,
qsos.t_psfmag_z,
qsos.t_psfmagerr_z,
qsos.objid,
qsos.oldname_type,
qsos.oldname_desig,
qsos.lon,
qsos.lat,
qsos.geopoint,
cat_qso.qid,
cat_qso.z_best qso_z_best,
cat_qso.imag qso_imag,
cat_qso.bal_flag  bal_flag,
cat_qso.bal_flag  bal_flag2,
cat_qso.z_fgal z_fgal,
cat_qso.spec_avesnr spec_avesnr,
cat_qso.spec_medsnr spec_medsnr,
cat_qso.spec_avesnr_red spec_avesnr_red,
cat_qso.spec_medsnr_red spec_medsnr_red,
cat_qso.w_limit_1216_1241 w_limit_1216_1241,
cat_qso.w_limit_1241_1400 w_limit_1241_1400,
cat_qso.w_limit_1400_1549 w_limit_1400_1549,
cat_qso.w_limit_1549_1909 w_limit_1549_1909,
cat_qso.w_limit_1909_2799 w_limit_1909_2799,
cat_qso.w_limit_2799_3969 w_limit_2799_3969,
cat_qso.w_limit_3969_8200 w_limit_3969_8200,
cat_sys.sid,
cat_sys.zab sys_zab,
cat_sys.lam_low sys_lam_low,
cat_sys.lam_high sys_lam_high,
cat_sys.grade sys_grade,
cat_sys.type sys_type,
cat_sys.beta sys_beta,
 cat_line.lid,
 cat_line.obs_lam line_obs_lam,
 cat_line.w_obs line_w_obs,
 cat_line.w_obserr line_w_obserr,
 cat_line.w_obs/(cat_sys.zab + 1)  line_w_rest,
 cat_line.w_obserr/(cat_sys.zab + 1) line_w_resterr,
 cat_line.ion_lam line_ion_lam,
 cat_line.ion_name line_ion_name,
 cat_line.ly_a line_ly_a,
 cat_line.deltaz line_deltaz,
  cat_line.deltav line_deltav,
  cat_line.snr line_snr,
  cat_line.fwhm line_fwhm
FROM 
  public.cat_line,
  public.qsos,
  public.cat_qso,
  public.cat_sys
WHERE 
  qsos.specid = cat_qso.specid AND
  cat_qso.qid = cat_sys.qid AND
  cat_sys.sid = cat_line.sid;


INSERT INTO
  cat_join_sys_mv
SELECT qsos.specid,
qsos.sdssname, 
qsos.ra, 
qsos.decl, 
qsos.redshift, 
qsos.psfmag_u, 
qsos.psfmagerr_u, 
qsos.psfmag_g, 
qsos.psfmagerr_g, 
qsos.psfmag_r, 
qsos.psfmagerr_r, 
qsos.psfmag_i, 
qsos.psfmagerr_i, 
qsos.psfmag_z, 
qsos.psfmagerr_z, 
qsos.a_u, 
qsos.lgnh, 
qsos.firstmag, 
qsos.first_sn, 
qsos.first_sep, 
qsos.lg_rass_rate, 
qsos.rass_sn, 
qsos.rass_sep, 
qsos.twomassmag_j, 
qsos.twomassmagerr_j, 
qsos.twomassmag_h, 
qsos.twomassmagerr_h, 
qsos.twomassmag_k, 
qsos.twomassmagerr_k, 
qsos.twomass_sep, 
qsos.twomass_flag, 
qsos.m_i, 
qsos.delgi, 
qsos.morphology, 
qsos.scienceprimary, 
qsos.mode, 
qsos.uniform, 
qsos.bestprimtarget, 
qsos.ts_b_lowz, 
qsos.ts_b_hiz, 
qsos.ts_b_first, 
qsos.ts_b_rosat, 
qsos.ts_b_serendip, 
qsos.ts_b_star, 
qsos.ts_b_gal, 
qsos.run_best, 
qsos.mjd_best, 
qsos.mjd, 
qsos.plate, 
qsos.fiber, 
qsos.rerun_best, 
qsos.camcol_best, 
qsos.field_best, 
qsos.obj_best, 
qsos.targprimtarget, 
qsos.ts_t_lowz, 
qsos.ts_t_hiz, 
qsos.ts_t_first, 
qsos.ts_t_rosat, 
qsos.ts_t_serendip, 
qsos.ts_t_star, 
qsos.ts_t_gal, 
qsos.t_psfmag_u, 
qsos.t_psfmagerr_u, 
qsos.t_psfmag_g, 
qsos.t_psfmagerr_g, 
qsos.t_psfmag_r, 
qsos.t_psfmagerr_r, 
qsos.t_psfmag_i, 
qsos.t_psfmagerr_i, 
qsos.t_psfmag_z, 
qsos.t_psfmagerr_z, 
qsos.objid, 
qsos.oldname_type, 
qsos.oldname_desig, 
qsos.lon, 
qsos.lat, 
qsos.geopoint,
cat_qso.qid,
cat_qso.z_best qso_z_best,
cat_qso.imag qso_imag,
cat_qso.bal_flag  bal_flag,
cat_qso.bal_flag2  bal_flag2,
cat_qso.z_fgal z_fgal,
cat_qso.spec_avesnr spec_avesnr,
cat_qso.spec_medsnr spec_medsnr,
cat_qso.spec_avesnr_red spec_avesnr_red,
cat_qso.spec_medsnr_red spec_medsnr_red,
cat_qso.w_limit_1216_1241 w_limit_1216_1241,
cat_qso.w_limit_1241_1400 w_limit_1241_1400,
cat_qso.w_limit_1400_1549 w_limit_1400_1549,
cat_qso.w_limit_1549_1909 w_limit_1549_1909,
cat_qso.w_limit_1909_2799 w_limit_1909_2799,
cat_qso.w_limit_2799_3969 w_limit_2799_3969,
cat_qso.w_limit_3969_8200 w_limit_3969_8200,
cat_sys.sid,
cat_sys.zab sys_zab,
cat_sys.lam_low sys_lam_low, 
cat_sys.lam_high sys_lam_high, 
cat_sys.grade sys_grade, 
cat_sys.type sys_type, 
cat_sys.beta sys_beta, 
array_agg(cat_line.lid) as arr_lid,
  array_agg(cat_line.lid) as agg_lid,
 array_agg(cat_line.obs_lam) as agg_line_obs_lam,
 array_agg(cat_line.w_obs) as agg_line_w_obs,
 array_agg(cat_line.w_obserr) as agg_line_w_obserr,
 array_agg(cat_line.w_obs/(1+cat_sys.zab)) as agg_line_w_rest,
 array_agg(cat_line.w_obserr/(1+cat_sys.zab)) as agg_line_w_resterr,
 array_agg(cat_line.ion_lam) as agg_line_ion_lam,
 array_agg(cat_line.ion_name) as agg_line_ion_name,
 array_agg(cat_line.ly_a) as agg_line_ly_a,
 array_agg(cat_line.deltaz) as agg_line_deltaz,
 array_agg(cat_line.deltav) as agg_line_deltav,
 array_agg(cat_line.snr) as agg_line_snr,
 array_agg(cat_line.fwhm) as agg_line_fwhm
FROM 
  public.cat_line, 
  public.qsos, 
  public.cat_qso, 
  public.cat_sys
WHERE 
  qsos.specid = cat_qso.specid AND
  cat_qso.qid = cat_sys.qid AND
  cat_sys.sid = cat_line.sid
GROUP BY 
qsos.specid, 
qsos.sdssname, 
qsos.ra, 
qsos.decl, 
qsos.redshift, 
qsos.psfmag_u, 
qsos.psfmagerr_u, 
qsos.psfmag_g, 
qsos.psfmagerr_g, 
qsos.psfmag_r, 
qsos.psfmagerr_r, 
qsos.psfmag_i, 
qsos.psfmagerr_i, 
qsos.psfmag_z, 
qsos.psfmagerr_z, 
qsos.a_u, 
qsos.lgnh, 
qsos.firstmag, 
qsos.first_sn, 
qsos.first_sep, 
qsos.lg_rass_rate, 
qsos.rass_sn, 
qsos.rass_sep, 
qsos.twomassmag_j, 
qsos.twomassmagerr_j, 
qsos.twomassmag_h, 
qsos.twomassmagerr_h, 
qsos.twomassmag_k, 
qsos.twomassmagerr_k, 
qsos.twomass_sep, 
qsos.twomass_flag, 
qsos.m_i, 
qsos.delgi, 
qsos.morphology, 
qsos.scienceprimary, 
qsos.mode, 
qsos.uniform, 
qsos.bestprimtarget, 
qsos.ts_b_lowz, 
qsos.ts_b_hiz, 
qsos.ts_b_first, 
qsos.ts_b_rosat, 
qsos.ts_b_serendip, 
qsos.ts_b_star, 
qsos.ts_b_gal, 
qsos.run_best, 
qsos.mjd_best, 
qsos.mjd, 
qsos.plate, 
qsos.fiber, 
qsos.rerun_best, 
qsos.camcol_best, 
qsos.field_best, 
qsos.obj_best, 
qsos.targprimtarget, 
qsos.ts_t_lowz, 
qsos.ts_t_hiz, 
qsos.ts_t_first, 
qsos.ts_t_rosat, 
qsos.ts_t_serendip, 
qsos.ts_t_star, 
qsos.ts_t_gal, 
qsos.t_psfmag_u, 
qsos.t_psfmagerr_u, 
qsos.t_psfmag_g, 
qsos.t_psfmagerr_g, 
qsos.t_psfmag_r, 
qsos.t_psfmagerr_r, 
qsos.t_psfmag_i, 
qsos.t_psfmagerr_i, 
qsos.t_psfmag_z, 
qsos.t_psfmagerr_z, 
qsos.objid, 
qsos.oldname_type, 
qsos.oldname_desig, 
qsos.lon, 
qsos.lat, 
qsos.geopoint,
cat_qso.qid,
cat_qso.z_best,
cat_qso.imag ,
cat_qso.bal_flag,
cat_qso.bal_flag2,
cat_qso.z_fgal,
cat_qso.spec_avesnr,
cat_qso.spec_medsnr,
cat_qso.spec_avesnr_red,
cat_qso.spec_medsnr_red,
cat_qso.w_limit_1216_1241,
cat_qso.w_limit_1241_1400,
cat_qso.w_limit_1400_1549,
cat_qso.w_limit_1549_1909,
cat_qso.w_limit_1909_2799,
cat_qso.w_limit_2799_3969,
cat_qso.w_limit_3969_8200,
cat_sys.sid,
cat_sys.zab,
cat_sys.lam_low , 
cat_sys.lam_high , 
cat_sys.grade , 
cat_sys.type, 
cat_sys.beta; 