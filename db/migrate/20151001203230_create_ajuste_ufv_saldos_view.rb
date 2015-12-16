class CreateAjusteUfvSaldosView < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE VIEW ajuste_ufv_saldos AS
      	SELECT 0 as em_of_c, t.empresa_id, d.catalogo_id, d.oficina_id, t.fechacbte, d.tlaux1, d.codtlaux1, Case When d.esdebito = 't' Then SUM(d.debe - d.haber) Else SUM(d.haber - d.debe) End saldo, Case When d.esdebito = 't' Then SUM(d.debesec - d.habersec) Else SUM(d.habersec - d.debesec) End saldosec, d.esdebito FROM (select id from catalogos  where idctaajusteufv >= 1 and  idctaacumajusteufv >=1 and activo = 't') c inner join diariodets d on c.id = d.catalogo_id inner join diarios t on t.id = d.diario_id  and t.tipocomprobante_id <> 5  WHERE t.esanulado='f' GROUP BY t.empresa_id, d.catalogo_id, d.oficina_id, t.fechacbte, d.tlaux1, d.codtlaux1, d.esdebito;
    SQL
  end 

  def down
    execute <<-SQL
      DROP VIEW ajuste_ufv_saldos;
    SQL
  end
end
