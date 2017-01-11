package main

import (
        "github.com/Sirupsen/logrus"
        "github.com/rancher/go-rancher/v2"
        "os"
        "flag"
        "strings"
)

func newCli() (*client.RancherClient, error){
        cattleURL := os.Getenv("CATTLE_URL")
        if len(cattleURL) == 0 {
                logrus.Info("CATTLE_URL is not set, skipping init of Rancher LB provider")
        }

        cattleAccessKey := os.Getenv("CATTLE_ACCESS_KEY")
        if len(cattleAccessKey) == 0 {
                logrus.Info("CATTLE_ACCESS_KEY is not set, skipping init of Rancher LB provider")
        }

        cattleSecretKey := os.Getenv("CATTLE_SECRET_KEY")
        if len(cattleSecretKey) == 0 {
                logrus.Info("CATTLE_SECRET_KEY is not set, skipping init of Rancher LB provider")
        }

        rancherCliOpts := &client.ClientOpts{
                Url:       cattleURL,
                AccessKey: cattleAccessKey,
                SecretKey: cattleSecretKey,
        }

        return client.NewRancherClient(rancherCliOpts)
}

func writeFile(name string, content []byte) {
        f, err := os.Create(name)
        if err != nil {
                logrus.Info("Failed to create file %s. Error: %v", name, err)
        }

        defer f.Close()

        _, err = f.Write(content)
        if err != nil {
                logrus.Info("Failed to write file %s. Error: %v", name, err)
        }
}

func getCert(cli *client.RancherClient, name string) (*client.Certificate, error) {
        certOpts := client.NewListOpts()
        certOpts.Filters["name"] = name
        certOpts.Filters["removed_null"] = "1"

        certs, err := cli.Certificate.List(certOpts)
        if err != nil {
                logrus.Info("Coudln't get certificate by name [%s]. Error: %#v", name, err)
                return nil, nil
        }

        if len(certs.Data) >= 1 {
                return &certs.Data[0], nil
        }
        return nil, nil
}

func main() {

        certificates := flag.String("name", "", "Rancher certificates name. Multiple values separated by ,")
        certDir := flag.String("dir", ".", "Path to save certificates.")
        flag.Parse()

        if len(*certificates) == 0 {
                logrus.Fatalf("Certificate name not set.")
        }

        certNames := strings.Split(*certificates, ",")
        certPath := *certDir

        rancherCli, err := newCli()

        if err != nil {
                logrus.Fatalf("Failed to create Rancher client %v", err)
        }

        for _, certName := range certNames {
                certData, err := getCert(rancherCli, certName)
                if err == nil {
                        writeFile(certPath + "/" + certName + ".crt",[]byte(certData.Cert))
                        writeFile(certPath + "/" + certName + ".key",[]byte(certData.Key))
                }
        }
}