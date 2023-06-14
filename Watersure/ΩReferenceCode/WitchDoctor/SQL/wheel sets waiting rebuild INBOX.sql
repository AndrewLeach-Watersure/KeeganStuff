
inbox
WH2RBD
Wheel Sets to Re-build
looks for wheel sets in the rstaus of "in repair", "to be repaired"
When 3 then red

hyperlinks to actual assets


select count(*)
from r5objects
where obj_rstatus in ('CIR','CRR')
and obj_class = 'WHLSET'