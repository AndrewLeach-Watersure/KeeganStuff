 insert into r5homeusers
  (hmu_homcode, hmu_homtype, hmu_user, hmu_seq, hmu_autofresh, hmu_tab)
  (select hmu_homcode, hmu_homtype, 'TO_USER', hmu_seq, hmu_autofresh, hmu_tab
  from r5homeusers where hmu_user = 'FROM_USER'
  and hmu_homcode not in (select  hmu_homcode from r5homeusers where hmu_user = 'TO_USER')
  )