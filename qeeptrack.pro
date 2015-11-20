TEMPLATE = app

QT += sql qml quick widgets positioning svg location sensors

ios {
    QMAKE_INFO_PLIST = Info.plist
}

SOURCES += main.cpp \
    satellitemodel.cpp \
    projection.cpp \
    Proj4/pj_init.c \
    Proj4/pj_transform.c \
    Proj4/pj_ctx.c \
    Proj4/pj_malloc.c \
    Proj4/pj_fileapi.c \
    Proj4/pj_fwd.c \
    Proj4/pj_fwd3d.c \
    Proj4/pj_inv.c \
    Proj4/pj_inv3d.c \
    Proj4/pj_list.c \
    Proj4/pj_param.c \
    Proj4/aasincos.c \
    Proj4/adjlon.c \
    Proj4/bch2bps.c \
    Proj4/bchgen.c \
    Proj4/biveval.c \
    Proj4/dmstor.c \
    Proj4/emess.c \
    Proj4/gen_cheb.c \
    Proj4/geocent.c \
    Proj4/geod_interface.c \
    Proj4/geod_set.c \
    Proj4/geodesic.c \
    Proj4/hypot.c \
    Proj4/jniproj.c \
    Proj4/mk_cheby.c \
    Proj4/nad_cvt.c \
    Proj4/nad_init.c \
    Proj4/nad_intr.c \
    Proj4/p_series.c \
    Proj4/PJ_aea.c \
    Proj4/PJ_aeqd.c \
    Proj4/PJ_airy.c \
    Proj4/PJ_aitoff.c \
    Proj4/pj_apply_gridshift.c \
    Proj4/pj_apply_vgridshift.c \
    Proj4/PJ_august.c \
    Proj4/pj_auth.c \
    Proj4/PJ_bacon.c \
    Proj4/PJ_bipc.c \
    Proj4/PJ_boggs.c \
    Proj4/PJ_bonne.c \
    Proj4/PJ_calcofi.c \
    Proj4/PJ_cass.c \
    Proj4/PJ_cc.c \
    Proj4/PJ_cea.c \
    Proj4/PJ_chamb.c \
    Proj4/PJ_collg.c \
    Proj4/PJ_crast.c \
    Proj4/pj_datum_set.c \
    Proj4/pj_datums.c \
    Proj4/PJ_denoy.c \
    Proj4/pj_deriv.c \
    Proj4/PJ_eck1.c \
    Proj4/PJ_eck2.c \
    Proj4/PJ_eck3.c \
    Proj4/PJ_eck4.c \
    Proj4/PJ_eck5.c \
    Proj4/pj_ell_set.c \
    Proj4/pj_ellps.c \
    Proj4/PJ_eqc.c \
    Proj4/PJ_eqdc.c \
    Proj4/pj_errno.c \
    Proj4/pj_factors.c \
    Proj4/PJ_fahey.c \
    Proj4/PJ_fouc_s.c \
    Proj4/PJ_gall.c \
    Proj4/pj_gauss.c \
    Proj4/pj_gc_reader.c \
    Proj4/pj_geocent.c \
    Proj4/PJ_geos.c \
    Proj4/PJ_gins8.c \
    Proj4/PJ_gn_sinu.c \
    Proj4/PJ_gnom.c \
    Proj4/PJ_goode.c \
    Proj4/pj_gridcatalog.c \
    Proj4/pj_gridinfo.c \
    Proj4/pj_gridlist.c \
    Proj4/PJ_gstmerc.c \
    Proj4/PJ_hammer.c \
    Proj4/PJ_hatano.c \
    Proj4/PJ_healpix.c \
    Proj4/PJ_igh.c \
    Proj4/PJ_imw_p.c \
    Proj4/pj_initcache.c \
    Proj4/PJ_isea.c \
    Proj4/PJ_krovak.c \
    Proj4/PJ_labrd.c \
    Proj4/PJ_laea.c \
    Proj4/PJ_lagrng.c \
    Proj4/PJ_larr.c \
    Proj4/PJ_lask.c \
    Proj4/pj_latlong.c \
    Proj4/PJ_lcc.c \
    Proj4/PJ_lcca.c \
    Proj4/pj_log.c \
    Proj4/PJ_loxim.c \
    Proj4/PJ_lsat.c \
    Proj4/PJ_mbt_fps.c \
    Proj4/PJ_mbtfpp.c \
    Proj4/PJ_mbtfpq.c \
    Proj4/PJ_merc.c \
    Proj4/PJ_mill.c \
    Proj4/pj_mlfn.c \
    Proj4/PJ_mod_ster.c \
    Proj4/PJ_moll.c \
    Proj4/pj_msfn.c \
    Proj4/pj_mutex.c \
    Proj4/PJ_natearth.c \
    Proj4/PJ_nell.c \
    Proj4/PJ_nell_h.c \
    Proj4/PJ_nocol.c \
    Proj4/PJ_nsper.c \
    Proj4/PJ_nzmg.c \
    Proj4/PJ_ob_tran.c \
    Proj4/PJ_ocea.c \
    Proj4/PJ_oea.c \
    Proj4/PJ_omerc.c \
    Proj4/pj_open_lib.c \
    Proj4/PJ_ortho.c \
    Proj4/pj_phi2.c \
    Proj4/PJ_poly.c \
    Proj4/pj_pr_list.c \
    Proj4/PJ_putp2.c \
    Proj4/PJ_putp3.c \
    Proj4/PJ_putp4p.c \
    Proj4/PJ_putp5.c \
    Proj4/PJ_putp6.c \
    Proj4/PJ_qsc.c \
    Proj4/pj_qsfn.c \
    Proj4/pj_release.c \
    Proj4/PJ_robin.c \
    Proj4/PJ_rpoly.c \
    Proj4/PJ_sch.c \
    Proj4/PJ_sconics.c \
    Proj4/PJ_somerc.c \
    Proj4/PJ_stere.c \
    Proj4/PJ_sterea.c \
    Proj4/pj_strerrno.c \
    Proj4/pj_strtod.c \
    Proj4/PJ_sts.c \
    Proj4/PJ_tcc.c \
    Proj4/PJ_tcea.c \
    Proj4/PJ_tmerc.c \
    Proj4/PJ_tpeqd.c \
    Proj4/pj_tsfn.c \
    Proj4/pj_units.c \
    Proj4/PJ_urm5.c \
    Proj4/PJ_urmfps.c \
    Proj4/pj_utils.c \
    Proj4/PJ_vandg.c \
    Proj4/PJ_vandg2.c \
    Proj4/PJ_vandg4.c \
    Proj4/PJ_wag2.c \
    Proj4/PJ_wag3.c \
    Proj4/PJ_wag7.c \
    Proj4/PJ_wink1.c \
    Proj4/PJ_wink2.c \
    Proj4/pj_zpoly1.c \
    Proj4/proj_etmerc.c \
    Proj4/proj_mdist.c \
    Proj4/proj_rouss.c \
    Proj4/rtodms.c \
    Proj4/vector1.c

RESOURCES += \
    qml.qrc

ICON = splash.icns

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

INCLUDEPATH += Proj4

HEADERS += \
    satellitemodel.h \
    projection.h \
    Proj4/proj_api.h \
    Proj4/projects.h \
    Proj4/geocent.h \
    Proj4/pj_list.h \
    Proj4/emess.h \
    Proj4/geod_interface.h \
    Proj4/geodesic.h \
    Proj4/nad_list.h \
    Proj4/org_proj4_PJ.h \
    Proj4/org_proj4_Projections.h \
    Proj4/proj_config.h

