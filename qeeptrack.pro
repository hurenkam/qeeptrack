TEMPLATE = app

QT += sql qml quick widgets positioning svg location sensors

ios {
    QMAKE_INFO_PLIST = Info.plist
}

SOURCES += main.cpp \
    satellitemodel.cpp \
    projection.cpp \
    proj.4/src/pj_init.c \
    proj.4/src/pj_transform.c \
    proj.4/src/pj_ctx.c \
    proj.4/src/pj_malloc.c \
    proj.4/src/pj_fileapi.c \
    proj.4/src/pj_fwd.c \
    proj.4/src/pj_fwd3d.c \
    proj.4/src/pj_inv.c \
    proj.4/src/pj_inv3d.c \
    proj.4/src/pj_list.c \
    proj.4/src/pj_param.c \
    proj.4/src/aasincos.c \
    proj.4/src/adjlon.c \
    proj.4/src/bch2bps.c \
    proj.4/src/bchgen.c \
    proj.4/src/biveval.c \
    proj.4/src/dmstor.c \
    proj.4/src/emess.c \
    proj.4/src/gen_cheb.c \
    proj.4/src/geocent.c \
    proj.4/src/geod_interface.c \
    proj.4/src/geod_set.c \
    proj.4/src/geodesic.c \
    proj.4/src/hypot.c \
    proj.4/src/jniproj.c \
    proj.4/src/mk_cheby.c \
    proj.4/src/nad_cvt.c \
    proj.4/src/nad_init.c \
    proj.4/src/nad_intr.c \
    proj.4/src/p_series.c \
    proj.4/src/PJ_aea.c \
    proj.4/src/PJ_aeqd.c \
    proj.4/src/PJ_airy.c \
    proj.4/src/PJ_aitoff.c \
    proj.4/src/pj_apply_gridshift.c \
    proj.4/src/pj_apply_vgridshift.c \
    proj.4/src/PJ_august.c \
    proj.4/src/pj_auth.c \
    proj.4/src/PJ_bacon.c \
    proj.4/src/PJ_bipc.c \
    proj.4/src/PJ_boggs.c \
    proj.4/src/PJ_bonne.c \
    proj.4/src/PJ_calcofi.c \
    proj.4/src/PJ_cass.c \
    proj.4/src/PJ_cc.c \
    proj.4/src/PJ_cea.c \
    proj.4/src/PJ_chamb.c \
    proj.4/src/PJ_collg.c \
    proj.4/src/PJ_crast.c \
    proj.4/src/pj_datum_set.c \
    proj.4/src/pj_datums.c \
    proj.4/src/PJ_denoy.c \
    proj.4/src/pj_deriv.c \
    proj.4/src/PJ_eck1.c \
    proj.4/src/PJ_eck2.c \
    proj.4/src/PJ_eck3.c \
    proj.4/src/PJ_eck4.c \
    proj.4/src/PJ_eck5.c \
    proj.4/src/pj_ell_set.c \
    proj.4/src/pj_ellps.c \
    proj.4/src/PJ_eqc.c \
    proj.4/src/PJ_eqdc.c \
    proj.4/src/pj_errno.c \
    proj.4/src/pj_factors.c \
    proj.4/src/PJ_fahey.c \
    proj.4/src/PJ_fouc_s.c \
    proj.4/src/PJ_gall.c \
    proj.4/src/pj_gauss.c \
    proj.4/src/pj_gc_reader.c \
    proj.4/src/pj_geocent.c \
    proj.4/src/PJ_geos.c \
    proj.4/src/PJ_gins8.c \
    proj.4/src/PJ_gn_sinu.c \
    proj.4/src/PJ_gnom.c \
    proj.4/src/PJ_goode.c \
    proj.4/src/pj_gridcatalog.c \
    proj.4/src/pj_gridinfo.c \
    proj.4/src/pj_gridlist.c \
    proj.4/src/PJ_gstmerc.c \
    proj.4/src/PJ_hammer.c \
    proj.4/src/PJ_hatano.c \
    proj.4/src/PJ_healpix.c \
    proj.4/src/PJ_igh.c \
    proj.4/src/PJ_imw_p.c \
    proj.4/src/pj_initcache.c \
    proj.4/src/PJ_isea.c \
    proj.4/src/PJ_krovak.c \
    proj.4/src/PJ_labrd.c \
    proj.4/src/PJ_laea.c \
    proj.4/src/PJ_lagrng.c \
    proj.4/src/PJ_larr.c \
    proj.4/src/PJ_lask.c \
    proj.4/src/pj_latlong.c \
    proj.4/src/PJ_lcc.c \
    proj.4/src/PJ_lcca.c \
    proj.4/src/pj_log.c \
    proj.4/src/PJ_loxim.c \
    proj.4/src/PJ_lsat.c \
    proj.4/src/PJ_mbt_fps.c \
    proj.4/src/PJ_mbtfpp.c \
    proj.4/src/PJ_mbtfpq.c \
    proj.4/src/PJ_merc.c \
    proj.4/src/PJ_mill.c \
    proj.4/src/pj_mlfn.c \
    proj.4/src/PJ_mod_ster.c \
    proj.4/src/PJ_moll.c \
    proj.4/src/pj_msfn.c \
    proj.4/src/pj_mutex.c \
    proj.4/src/PJ_natearth.c \
    proj.4/src/PJ_nell.c \
    proj.4/src/PJ_nell_h.c \
    proj.4/src/PJ_nocol.c \
    proj.4/src/PJ_nsper.c \
    proj.4/src/PJ_nzmg.c \
    proj.4/src/PJ_ob_tran.c \
    proj.4/src/PJ_ocea.c \
    proj.4/src/PJ_oea.c \
    proj.4/src/PJ_omerc.c \
    proj.4/src/pj_open_lib.c \
    proj.4/src/PJ_ortho.c \
    proj.4/src/pj_phi2.c \
    proj.4/src/PJ_poly.c \
    proj.4/src/pj_pr_list.c \
    proj.4/src/PJ_putp2.c \
    proj.4/src/PJ_putp3.c \
    proj.4/src/PJ_putp4p.c \
    proj.4/src/PJ_putp5.c \
    proj.4/src/PJ_putp6.c \
    proj.4/src/PJ_qsc.c \
    proj.4/src/pj_qsfn.c \
    proj.4/src/pj_release.c \
    proj.4/src/PJ_robin.c \
    proj.4/src/PJ_rpoly.c \
    proj.4/src/PJ_sch.c \
    proj.4/src/PJ_sconics.c \
    proj.4/src/PJ_somerc.c \
    proj.4/src/PJ_stere.c \
    proj.4/src/PJ_sterea.c \
    proj.4/src/pj_strerrno.c \
    proj.4/src/pj_strtod.c \
    proj.4/src/PJ_sts.c \
    proj.4/src/PJ_tcc.c \
    proj.4/src/PJ_tcea.c \
    proj.4/src/PJ_tmerc.c \
    proj.4/src/PJ_tpeqd.c \
    proj.4/src/pj_tsfn.c \
    proj.4/src/pj_units.c \
    proj.4/src/PJ_urm5.c \
    proj.4/src/PJ_urmfps.c \
    proj.4/src/pj_utils.c \
    proj.4/src/PJ_vandg.c \
    proj.4/src/PJ_vandg2.c \
    proj.4/src/PJ_vandg4.c \
    proj.4/src/PJ_wag2.c \
    proj.4/src/PJ_wag3.c \
    proj.4/src/PJ_wag7.c \
    proj.4/src/PJ_wink1.c \
    proj.4/src/PJ_wink2.c \
    proj.4/src/pj_zpoly1.c \
    proj.4/src/proj_etmerc.c \
    proj.4/src/proj_mdist.c \
    proj.4/src/proj_rouss.c \
    proj.4/src/rtodms.c \
    proj.4/src/vector1.c

RESOURCES += \
    qml.qrc

ICON = splash.icns

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

INCLUDEPATH += proj.4/src

HEADERS += \
    satellitemodel.h \
    projection.h \
    proj.4/src/proj_api.h \
    proj.4/src/projects.h \
    proj.4/src/geocent.h \
    proj.4/src/pj_list.h \
    proj.4/src/emess.h \
    proj.4/src/geod_interface.h \
    proj.4/src/geodesic.h \
    proj.4/src/nad_list.h \
    proj.4/src/org_proj4_PJ.h \
    proj.4/src/org_proj4_Projections.h \
    proj.4/src/proj_config.h

