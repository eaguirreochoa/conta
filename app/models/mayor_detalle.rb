class MayorDetalle < ActiveRecord::Base
	#self.table_name = 'mayor_detalle'
  	#after_initialize :readonly!
  	scope :between, -> (start_datetime, end_datetime) {
    where("fechacbte between ? and ?", start_datetime, end_datetime)
  	}
end