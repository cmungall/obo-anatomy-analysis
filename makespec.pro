all <-- 'all-stats.tbl'.

loc('FBbt','fly/fly_anatomy.obo').
loc('ZFA','fish/zebrafish_anatomy.obo').
loc('AAO','amphibian/amphibian_anatomy.obo').
loc('TAO','fish/teleost_anatomy.obo').
loc('MA','mouse/adult_mouse_anatomy.obo').
loc('XAO','frog/xenopus_anatomy.obo').
%loc('VHOG','multispecies/vhog.obo').
loc('VSAO','multispecies/vsao.obo').
loc('UBERON','multispecies/uberon.obo').

yr_ont(Year,Ont) :-
        ontpath(Year,Ont,_,_).
ontpath(Year,Ont,Path,S) :-
        loc(S,Loc),
        downcase_atom(S,Ont),
        yr(Year),
        concat_atom(['anatomy-',Year,'/',Loc],Path).

'all-stats.tbl' <-- Deps,
  {findall(t(['stats-',Year,'-',Ont,'.tbl']),
           yr_ont(Year,Ont),
           Deps)},
  'sort stats-*-*.tbl > $@'.


'stats-$Year-$Ont.tbl' <-- [],
  {ontpath(Year,Ont,Path,IDSpace), exists_file(Path)},
  'blip-findall -i $Path "aggregate(count,C,(class(C),id_idspace(C,\'$IDSpace\')),Num)" -select "num_classes(\'$Year\',$Ont,Num)" > $@'.

'stats-$Year-$Ont.tbl' <-- [],
  {ontpath(Year,Ont,Path,IDSpace), \+ exists_file(Path), writeln(no_stats_for(Path))},
  'touch $@'.

% for Venn diagram

% terms in EXT that originated in (and are still in) core. Note that each of these have multiple sources
'idlist-core.ids' <-- [],
  'blip-findall -r pext "class(ID),id_idspace(ID,\'UBERON\'),ID@<\'UBERON:2000000\'" -select ID | sort -u > $@'.

% terms in EXT that came from TAO; either via route1 - integration into core (the intersection with the set above) or route2 - by lifting into EXT with UBERON:2x range
'idlist-tao.ids' <-- [],
  'blip-findall -r pext "class(ID),id_idspace(ID,\'UBERON\'),(entity_xref_idspace(ID,_,\'TAO\');(ID@>=\'UBERON:2000000\',ID@<\'UBERON:3000000\'))" -select ID | sort -u > $@'.

% terms in EXT that came from AAO; either via route1 - integration into core (the intersection with the core above) or route2 - by lifting into EXT with UBERON:3x range
'idlist-aao.ids' <-- [],
  'blip-findall -r pext "class(ID),id_idspace(ID,\'UBERON\'),(entity_xref_idspace(ID,_,\'AAO\');(ID@>=\'UBERON:3000000\',ID@<\'UBERON:4000000\'))" -select ID | sort -u > $@'.

% terms in EXT that came from VSAO; either via route1 - integration into core (the intersection with the core above - most of them) or route2 - by lifting into EXT with UBERON:40x range
'idlist-vsao.ids' <-- [],
  'blip-findall -r pext "class(ID),id_idspace(ID,\'UBERON\'),(entity_xref_idspace(ID,_,\'VSAO\');(ID@>=\'UBERON:4000000\',ID@<\'UBERON:4000300\'))" -select ID | sort -u > $@'.

'Venn-CTA.png' <-- [],
  './src/venn.pl Core idlist-core.ids TAO idlist-tao.ids AAO idlist-aao.ids $@'.
'Venn-CTV.png' <-- [],
  './src/venn.pl Core idlist-core.ids TAO idlist-tao.ids VSAO idlist-vsao.ids $@'.
'Venn-ATV.png' <-- [],
  './src/venn.pl AAO idlist-aao.ids TAO idlist-tao.ids VSAO idlist-vsao.ids $@'.


yr('2005').
yr('2006').
yr('2007').
yr('2008').
yr('2009').
yr('2010').
yr('2011').
yr('2012').
yr('2013').
yr('2013_06').




