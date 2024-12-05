export interface PrivatePackage {
  bucket: string;
  path: string;
  upload?: {
    directory?: string;
  };
  server?: Server;
}

interface Server {
  port?: number;
  bindAddress?: string;
  certificate?: {
    path: string;
    password?: string;
  };
}

export interface Location {
  id: string;
  description: string;
  region: string;
  subnets: string[];
  "security-groups": string[];
  "instance-type": string;
  spot?: boolean;
  ami: AMI;
  engine: string;
  "elastic-ips"?: string[];
  tags?: Record<string, string>;
  "tags-for"?: TagsFor;
  "profile-name"?: string;
  "iam-instance-profile"?: string;
  "system-properties"?: Record<string, string>;
  "java-home"?: string;
  "jvm-options"?: string[];
  "enterprise-cloud"?: enterpriseCloud;
}

interface AMI {
  type: string;
  java?: string;
  image?: string;
  id?: string;
}

interface TagsFor {
  instance?: Record<string, string>;
  volume?: Record<string, string>;
  "network-interface"?: Record<string, string>;
}

export interface enterpriseCloud {
  url?: string;
}
