class CreateMayorDetallesView < ActiveRecord::Migration
def up
    execute <<-SQL
      CREATE VIEW mayor_detalles AS
      	select (t.empresa_id || d.oficina_id || d.catalogo_id) as em_of_c, t.id, d.catalogo_id, t.empresa_id, e.sigla as empresa, tc.sigla as tipocbte, t.origenasiento_id, t.nrocbte, t.fechacbte, d.item, c.codigo, d.oficina_id, o.sigla as oficina ,d.debe, d.haber, d.debesec, d.habersec, d.tlaux1, d.codtlaux1, d.tlaux2, d.codtlaux2, t.glosagral, t.tc, d.moneda_id, d.tcsec, d.esdebito from diarios t inner join diariodets d on t.id = d.diario_id and t.tipocomprobante_id <> 5 inner join catalogos c on c.id = d.catalogo_id inner join tipocomprobantes tc on tc.id = t.tipocomprobante_id inner join empresas e on e.id = t.empresa_id inner join oficinas o on o.id = d.oficina_id where t.esanulado = 'f';

    SQL
  end

  def down
    execute <<-SQL
      DROP VIEW mayor_detalles; 
    SQL
  end
end
