class CreateSaldoDetsView < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE VIEW saldo_dets AS
      	SELECT (t.empresa_id || d.oficina_id || d.catalogo_id) as em_of_c, t.empresa_id, d.catalogo_id, d.oficina_id,d.tlaux1, d.codtlaux1, t.fechacbte, n.numnivel, c.padre_id, g.naturaleza, SUM(d.debe) debe, SUM(d.haber) haber, SUM(d.debesec) debesec, SUM(d.habersec) habersec, case when esbalance = 't' and esestresul = 'f' and g.naturaleza = 'D' then 'ACT' when esbalance = 't' and esestresul = 'f' and g.naturaleza = 'A' then 'PAS' when esbalance = 'f' and esestresul = 't' and g.naturaleza = 'D' then 'GAS' when esbalance = 'f' and esestresul = 't' and g.naturaleza = 'A'  then 'ING' else 'PAT' end tipo FROM diarios t INNER JOIN diariodets d on t.tipocomprobante_id <> 5 and t.id = d.diario_id INNER JOIN catalogos c on c.id = d.catalogo_id and c.activo = 't' INNER JOIN grupos g on g.id = c.grupo_id inner join nivels n on n.id = c.nivel_id  WHERE t.esanulado = 'f' GROUP BY t.empresa_id, d.catalogo_id, d.oficina_id, d.tlaux1, d.codtlaux1, t.fechacbte, esbalance, esestresul, g.naturaleza, n.numnivel, c.padre_id ;
    SQL
  end 

  def down
    execute <<-SQL
      DROP VIEW saldo_dets;
    SQL
  end
end
