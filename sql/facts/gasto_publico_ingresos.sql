DROP TABLE IF EXISTS fact.gasto_publico_en_ingresos;

CREATE TABLE fact.gasto_publico_en_ingresos AS (

SELECT  *
FROM    datosgobar.gasto_publico_en_ingresos
UNPIVOT (gasto 
        FOR prestacion IN (
            asignaciones_familiares,
            argentina_trabaja,
            asignacion_universal_hijo_proteccion_social,
            becas,
            jovenes_mas_mejor_trabajo,
            jubilaciones_pensiones_sist_int_previsional_argentino,
            jubilaciones_pensiones_otros_regimenes_nacionales,
            otras_politicas_empleo_minist_trabajo_empleo_seg_soc,
            pensiones_no_contributivas,
            programa_jefas_jefes_hogar_desocupados,
            plan_familias_inclusion_social,
            programa_respaldo_estudiantes_argentina,
            pension_universal_adulto_mayor,
            seguro_capacitacion_empleo,
            seguro_desempleo,
            seguro_desempleo_renatre,
            proyectos_productivos_comunitarios
        )
        )
);