class CreateMayorSaldosView < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE VIEW mayor_saldos AS
      	SELECT 0 as em_of_c, t.empresa_id, d.catalogo_id, d.oficina_id, t.fechacbte, Case When d.esdebito = 't' Then SUM(d.debe - d.haber) Else SUM(d.haber - d.debe) End saldo, Case When d.esdebito = 't' Then SUM(d.debesec - d.habersec) Else SUM(d.habersec - d.debesec) End saldosec FROM diarios t INNER JOIN diariodets d on t.id = d.diario_id and t.tipocomprobante_id <> 5 WHERE t.esanulado='f' GROUP BY t.empresa_id, d.catalogo_id, d.oficina_id, t.fechacbte, d.esdebito;
    SQL
  end 

  def down
    execute <<-SQL
      DROP VIEW mayor_saldos;
    SQL
  end
end
