import React from "react";

import GlobalApi from "~/logic/api/global";
import { StoreState } from "~/logic/store/type";
import { Association } from "~/types";
import { RouteComponentProps } from "react-router-dom";
import { NotebookRoutes } from "./components/lib/NotebookRoutes";

type PublishResourceProps = StoreState & {
  association: Association;
  api: GlobalApi;
  baseUrl: string;
} & RouteComponentProps;

export function PublishResource(props: PublishResourceProps) {
  const { association, api, baseUrl, notebooks } = props;
  const appPath = association["app-path"];
  const [, ship, book] = appPath.split("/");
  const notebook = notebooks[ship][book];
  const notebookContacts = props.contacts[association["group-path"]];

  return (
    <NotebookRoutes
      api={api}
      ship={ship}
      book={book}
      contacts={props.contacts}
      groups={props.groups}
      notebook={notebook}
      notebookContacts={notebookContacts}
      rootUrl={baseUrl}
      baseUrl={`${baseUrl}/resource/publish/${ship}/${book}`}
      history={props.history}
      match={props.match}
      location={props.location}
    />
  );
}
