import { Component } from "react";

export type Method = "GET" | "POST" | "DELETE" | "PUT" | "PATCH";

export type Links =
  | {
      name: string;
      href: string;
      type?: null | "link";
      external?: boolean | null;
    }
  | {
      name: string;
      comp: (props: { hidden?: boolean }) => JSX.Element | null;
      state: state_nav;
      type: "component";
    };


export type state_nav = {
  change: React.Dispatch<React.SetStateAction<boolean>>;
  value: boolean;
}