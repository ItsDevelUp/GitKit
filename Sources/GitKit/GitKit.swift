//
//  GitKit.swift
//  pruebas
//
//  Created by Asiel Cabrera Gonzalez on 27/7/21.
//

import Foundation
import TerminalKit

public final class Git: Terminal {

    public enum Alias {
        case cmd(Command, String? = nil)
        case addAll
        case commit(message: String, Bool = false)
        case clone(url: String)
        case checkout(branch: String)
        case log(Int? = nil)
        case push(remote: String? = nil, branch: String? = nil)
        case pull(remote: String? = nil, branch: String? = nil)
        case merge(branch: String)
        case create(branch: String)
        case delete(branch: String)
        case tag(String)
        case raw(String)

        private func commandParams() -> [String] {
            var params: [String] = []
            switch self {
            case .cmd(let command, let args):
                params = [command.rawValue]
                if let args = args {
                    params.append(args)
                }
            case .addAll:
                params = [Command.add.rawValue, "."]
            case .commit(let message, let allowEmpty):
                params = [Command.commit.rawValue, "-m", "\"\(message)\""]
                if allowEmpty {
                    params.append("--allow-empty")
                }
            case .clone(let url):
                params = [Command.clone.rawValue, url]
            case .checkout(let branch):
                params = [Command.checkout.rawValue, branch]
            case .log(let n):
                params = [Command.log.rawValue]
                if let n = n {
                    params.append("-\(n)")
                }
            case .push(let remote, let branch):
                params = [Command.push.rawValue]
                if let remote = remote {
                    params.append(remote)
                }
                if let branch = branch {
                    params.append(branch)
                }
            case .pull(let remote, let branch):
                params = [Command.pull.rawValue]
                if let remote = remote {
                    params.append(remote)
                }
                if let branch = branch {
                    params.append(branch)
                }
            case .merge(let branch):
                params = [Command.merge.rawValue, branch]
            case .create(let branch):
                params = [Command.checkout.rawValue, "-b", branch]
            case .delete(let branch):
                params = [Command.branch.rawValue, "-D", branch]
            case .tag(let name):
                params = [Command.tag.rawValue, name]
            case .raw(let command):
                params.append(command)
            }
            return params
        }
        
        public var rawValue: String {
            self.commandParams().joined(separator: " ")
        }
    }

    public enum Command: String {
        
        case config, clean, clone, add, mv, reset, rm, bisect, grep
        case log, show, status, branch, checkout, commit, diff, merge
        case rebase, tag, fetch, pull, push
        case initialize = "init"

    }
    
    private func rawCommand(_ alias: Alias) -> String {
        var cmd: [String] = []
        
        if let path = self.path {
            if
                alias.rawValue.hasPrefix(Command.initialize.rawValue) ||
                alias.rawValue.hasPrefix(Command.clone.rawValue)
            {
                cmd += ["mkdir", "-p", path, "&&"]
            }
            cmd += ["cd", path, "&&"]
        }
        cmd += ["git", alias.rawValue]
        
        let command = cmd.joined(separator: " ")

        if self.verbose {
            print(command)
        }
        return command
    }
    
    public var path: String?
    
    public var verbose = false
    
    public init(path: String? = nil, type: ShellType, env: [String: String] = [:]) {
        self.path = path

        super.init(type: type, env: env)
    }

    @discardableResult
    public func run(_ alias: Alias) throws -> String {
        try self.execute(self.rawCommand(alias))
    }
    public func run(_ alias: Alias, completion: @escaping ((String?, Swift.Error?) -> Void)) {
        self.execute(self.rawCommand(alias), completion: completion)
    }
}

