
loc('FBbt','fly/fly_anatomy.obo').
loc('ZFA','fish/zebrafish.obo').
loc('AAO','amphibian/amphibian_anatomy.obo').
loc('MA','mouse/adult_mouse_anatomy.obo').
loc('XAO','frog/xenopus_anatomy.obo').
loc('UBERON','multispecies/uberon.obo').

yr(2005).
yr(2006).
yr(2007).
yr(2008).
yr(2009).
yr(2010).
yr(2011).
yr(2012).
yr(2013).

yr_ont(Year,Ont) :-
        ontpath(Year,Ont,_,_).
ontpath(Year,Ont,Path,S) :-
        loc(S,Loc),
        downcase_atom(S,Ont),
        yr(YearNum),
        concat_atom([YearNum],Year),
        concat_atom(['anatomy-',Year,'/',Loc],Path).

'all-stats.tbl' <-- Deps,
  {findall(t(['stats-',Year,'-',Ont,'.tbl']),
           yr_ont(Year,Ont),
           Deps)},
  'cat stats-*-*.tbl > $@'.


'stats-$Year-$Ont.tbl' <-- [],
  {ontpath(Year,Ont,Path,IDSpace), exists_file(Path)},
  'blip-findall -i $Path "aggregate(count,C,(class(C),id_idspace(C,\'$IDSpace\')),Num)" -select "num_classes($Year,$Ont,Num)" > $@'.

'stats-$Year-$Ont.tbl' <-- [],
  {ontpath(Year,Ont,Path,IDSpace), \+ exists_file(Path)},
  'touch $@'.




