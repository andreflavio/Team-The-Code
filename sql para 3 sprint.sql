// select do professor Arley.

SELECT 
        b.id AS idproject, 
        b.name, 
        COUNT(*)::integer AS total_grids, -- quantidade de grades do projeto
        COALESCE(c.finished, 0)::integer AS finished_grids, -- quantidade de grades finalizadas do projeto
       
        COALESCE(c.finished_area, 0) AS finished_area -- área das grades finalizadas do projeto 
		b.area_km2 AS total_area, -- área do projeto
      FROM 
          grids AS a
      JOIN 
          projects AS b ON a.idproject = b.id
      LEFT JOIN (
          SELECT 
              idproject, 
              COUNT(*) AS finished,
              SUM(area_km2) AS finished_area
          FROM 
              grids
          WHERE 
              status = 'finalizado'
          GROUP BY 
              idproject
      ) AS c 
      ON a.idproject = c.idproject
      GROUP BY 
          b.id, b.name, c.finished, c.finished_area
      ORDER BY 
          b.name  
		  
		  
// Quantidade de grades por projeto, quantidade de grades finalizadas no projeto,
// área do projeto e área das grades finalizadas do projeto   
// acrescentei a coluna validated_grids 

	SELECT 
    b.id AS idproject, 
    b.name, 
    COUNT(*)::integer AS total_grids, -- quantidade de grades do projeto
    COALESCE(c.finished, 0)::integer AS finished_grids, -- quantidade de grades finalizadas do projeto
    COALESCE(d.validated, 0)::integer AS validated_grids, -- quantidade de grades validadas do projeto
    
    COALESCE(c.finished_area, 0) AS finished_area, -- área das grades finalizadas do projeto
	b.area_km2 AS total_area -- área do projeto
FROM 
    grids AS a
JOIN 
    projects AS b ON a.idproject = b.id
LEFT JOIN (
    SELECT 
        idproject, 
        COUNT(*) AS finished,
        SUM(area_km2) AS finished_area
    FROM 
        grids
    WHERE 
        status = 'finalizado'
    GROUP BY 
        idproject
) AS c 
ON a.idproject = c.idproject
LEFT JOIN (
    SELECT 
        idproject,
        COUNT(*) AS validated
    FROM 
        grids
    WHERE 
        status_val = 'finalizado'
    GROUP BY 
        idproject
) AS d 
ON a.idproject = d.idproject
GROUP BY 
    b.id, b.name, c.finished, c.finished_area, d.validated
ORDER BY 
    b.name;



// testar se o select acima está correto

SELECT 
    COUNT(*) AS obs
FROM 
    grids
WHERE 
    obs = 'not null';





finished_grids

Descrição: Este campo representa a quantidade total de grades finalizadas em um projeto.
Origem: Este dado é obtido da subconsulta c, que conta o número de grades (grids) em um 
determinado projeto (idproject) onde o status é 'finalizado'.
Uso: Ele indica quantas grades, no total, foram concluídas para um projeto específico, sem levar 
em consideração quem as finalizou.

finish_count

Descrição: Este campo representa a quantidade de grades finalizadas por cada editor em um projeto.
Origem: Este dado é obtido da subconsulta e, que conta o número de grades (grids) finalizadas por
 cada editor (user_editor) dentro de um determinado projeto (idproject), onde o status é 'finalizado'.
Uso: Ele permite entender a contribuição de cada editor para as finalizações dentro de um projeto 
específico, mostrando quantas grades foram concluídas por cada editor.



SELECT 
    b.id AS idproject, 
    b.name, 
    COUNT(*)::integer AS total_grids, -- quantidade de grades do projeto
    COALESCE(c.finished, 0)::integer AS finished_grids, -- quantidade de grades finalizadas do projeto
    COALESCE(d.validated, 0)::integer AS validated_grids, -- quantidade de grades validadas do projeto
    COALESCE(c.finished_area, 0) AS finished_area, -- área das grades finalizadas do projeto
    b.area_km2 AS total_area, -- área do projeto
    COALESCE(e.user_editor, 0) AS editor_id, -- ID do editor
    COALESCE(e.finish_count, 0)::integer AS finish_count -- quantidade de finalizações por editor
FROM 
    grids AS a
JOIN 
    projects AS b ON a.idproject = b.id
LEFT JOIN (
    SELECT 
        idproject, 
        COUNT(*) AS finished,
        SUM(area_km2) AS finished_area
    FROM 
        grids
    WHERE 
        status = 'finalizado'
    GROUP BY 
        idproject
) AS c 
ON a.idproject = c.idproject
LEFT JOIN (
    SELECT 
        idproject,
        COUNT(*) AS validated
    FROM 
        grids
    WHERE 
        status_val = 'finalizado'
    GROUP BY 
        idproject
) AS d 
ON a.idproject = d.idproject
LEFT JOIN (
    SELECT 
        idproject,
        user_editor,
        COUNT(*) AS finish_count
    FROM 
        grids
    WHERE 
        status = 'finalizado'
    GROUP BY 
        idproject, user_editor
) AS e 
ON a.idproject = e.idproject
GROUP BY 
    b.id, b.name, c.finished, c.finished_area, d.validated, e.user_editor, e.finish_count
ORDER BY 
    b.name;
