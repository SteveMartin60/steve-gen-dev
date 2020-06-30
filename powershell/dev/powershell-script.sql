={query(CreateRestorePoint    , "SELECT *                                                       );
  query(FW_CommandsSet        , "SELECT C WHERE C <> '' AND (D = 'All' OR D = '" & Target & "')");
  query(FW_CommandsEnable     , "SELECT B WHERE B <> '' AND (C = 'All' OR C = '" & Target & "')");
  query(MiscPolicies          , "SELECT A WHERE A <> '' AND (B = 'All' OR B = '" & Target & "')");
  query(DisableApps           , "SELECT B WHERE B <> '' AND (C = 'All' OR C = '" & Target & "')");
  query(DisableDefaultAccounts, "SELECT A WHERE A <> '' AND (B = 'All' OR B = '" & Target & "')");
  query(Services              , "SELECT C WHERE C <> '' AND (D = 'All' OR D = '" & Target & "')");
  query(RegKeys               , "SELECT E WHERE E <> ''                                        ");
  query(UninstallApps         , "SELECT B WHERE B <> '' AND (C = 'All' OR C = '" & Target & "')");
  query(char(13))
  }