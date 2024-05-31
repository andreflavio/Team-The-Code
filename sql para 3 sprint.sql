// select do professor Arley.

SELECT 
        b.id AS idproject, 
        b.name, 
        COUNT(*)::integer AS total_grids, -- quantidade de grades do projeto
        COALESCE(c.finished, 0)::integer AS finished_grids, -- quantidade de grades finalizadas do projeto
        b.area_km2 AS total_area, -- área do projeto
        COALESCE(c.finished_area, 0) AS finished_area -- área das grades finalizadas do projeto
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
    b.area_km2 AS total_area, -- área do projeto
    COALESCE(c.finished_area, 0) AS finished_area -- área das grades finalizadas do projeto
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
    COUNT(*) AS validated_grids
FROM 
    grids
WHERE 
    status_val = 'finalizado';
