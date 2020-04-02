-- Insert objects

DECLARE
  lv_elf ELF_T;
BEGIN
  INSERT INTO tolkien VALUES (tolkien_s.NEXTVAL, man_t('Boromir', 'Men'));
  INSERT INTO tolkien VALUES (tolkien_s.NEXTVAL, man_t('Faramir', 'Men'));
  INSERT INTO tolkien VALUES (tolkien_s.NEXTVAL, hobbit_t('Bilbo', 'Hobbits'));
  INSERT INTO tolkien VALUES (tolkien_s.NEXTVAL, hobbit_t('Frodo', 'Hobbits'));
  INSERT INTO tolkien VALUES (tolkien_s.NEXTVAL, hobbit_t('Merry', 'Hobbits'));
  INSERT INTO tolkien VALUES (tolkien_s.NEXTVAL, hobbit_t('Pippin', 'Hobbits'));
  INSERT INTO tolkien VALUES (tolkien_s.NEXTVAL, hobbit_t('Samwise', 'Hobbits'));
  INSERT INTO tolkien VALUES (tolkien_s.NEXTVAL, dwarf_t('Gimli', 'Dwarves'));

  -- Insert elves. Logically it would make more sense to just include a name
  -- field in the constructors, but that's not what the requirements show...
  lv_elf := noldor_t('Noldor');
  lv_elf.set_name('Feanor');
  INSERT INTO tolkien VALUES (tolkien_s.NEXTVAL, lv_elf);

  lv_elf := silvan_t('Silvan');
  lv_elf.set_name('Tauriel');
  INSERT INTO tolkien VALUES (tolkien_s.NEXTVAL, lv_elf);

  lv_elf := teleri_t('Teleri');
  lv_elf.set_name('Earwen');
  INSERT INTO tolkien VALUES (tolkien_s.NEXTVAL, lv_elf);

  lv_elf := teleri_t('Teleri');
  lv_elf.set_name('Celeborn');
  INSERT INTO tolkien VALUES (tolkien_s.NEXTVAL, lv_elf);

  lv_elf := sindar_t('Sindar');
  lv_elf.set_name('Thranduil');
  INSERT INTO tolkien VALUES (tolkien_s.NEXTVAL, lv_elf);

  lv_elf := sindar_t('Sindar');
  lv_elf.set_name('Legolas');
  INSERT INTO tolkien VALUES (tolkien_s.NEXTVAL, lv_elf);

  INSERT INTO tolkien VALUES (tolkien_s.NEXTVAL, orc_t('Azog the Defiler', 'Orcs'));
  INSERT INTO tolkien VALUES (tolkien_s.NEXTVAL, orc_t('Bolg', 'Orcs'));
  INSERT INTO tolkien VALUES (tolkien_s.NEXTVAL, maia_t('Gandalf the Grey', 'Maiar'));
  INSERT INTO tolkien VALUES (tolkien_s.NEXTVAL, maia_t('Radagast the Brown', 'Maiar'));
  INSERT INTO tolkien VALUES (tolkien_s.NEXTVAL, maia_t('Saruman the White', 'Maiar'));
  INSERT INTO tolkien VALUES (tolkien_s.NEXTVAL, goblin_t('The Great Goblin', 'Goblins'));
  INSERT INTO tolkien VALUES (tolkien_s.NEXTVAL, man_t('Aragorn', 'Men'));
END;
/

QUIT;
