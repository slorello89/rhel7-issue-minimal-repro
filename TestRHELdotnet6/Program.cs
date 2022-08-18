using System.Net.Security;
using System;
using System.Security.Authentication;
using StackExchange.Redis;

var host = Environment.GetEnvironmentVariable("rp_ip") ?? "localhost";
var options = new ConfigurationOptions();
options.EndPoints.Add($"{host}:12000");
options.Ssl = true;
// options.Password = "your_password";
options.SslProtocols = SslProtocols.Tls12;

options.CertificateValidation += (sender, certificate, chain, errors) =>
{
    Console.WriteLine(errors);
    return true;
};

var muxer = ConnectionMultiplexer.Connect(options);
var db = muxer.GetDatabase();

db.StringSet("foo", "bar");
Console.WriteLine("Completed. . .");