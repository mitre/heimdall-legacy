require 'rails_helper'

RSpec.describe Control, type: :model do
  context 'with Control' do
    let(:control) { FactoryBot.build(:control) }
    let(:bad_code) { "control \"V-71849\" do\n  title \"The file permissions, ownership, and group membership of system files and\ncommands must match the vendor values.\"\n  desc  \"\n    Discretionary access control is weakened if a user or group has access\npermissions to system files and directories greater than the default.\n\n    Satisfies: SRG-OS-000257-GPOS-00098, SRG-OS-000278-GPOS-0010.\n  \"\n  impact \"nada\"\n  tag \"severity\": \"high\"\n  tag \"gtitle\": \"SRG-OS-000257-GPOS-00098\"\n  tag \"gid\": \"V-71849\"\n  tag \"rid\": \"SV-86473r2_rule\"\n  tag \"stig_id\": \"RHEL-07-010010\"\n  tag \"cci\": \"CCI-001494\"\n  tag \"nist\": [\"AU-9\", \"Rev_4\"]\n  tag \"cci\": \"CCI-001496\"\n  tag \"nist\": [\"AU-9 (3)\", \"Rev_4\"]\n  tag \"check\": \"Verify the file permissions, ownership, and group membership of\nsystem files and commands match the vendor values.\n\nCheck the file permissions, ownership, and group membership of system files and\ncommands with the following command:\n\n# rpm -Va | grep '^.M'\n\nIf there is any output from the command indicating that the ownership or group of a\nsystem file or command, or a system file, has permissions less restrictive than the\ndefault, this is a finding.\"\n\n  tag \"fix\": \"Run the following command to determine which package owns the file:\n\n# rpm -qf <filename>\n\nReset the permissions of files within a package with the following command:\n\n#rpm --setperms <packagename>\n\nReset the user and group ownership of files within a package with the following\ncommand:\n\n#rpm --setugids <packagename>\"\n\n  # @todo add puppet content to fix any rpms that get out of wack\n  describe command(\"rpm -Va | grep '^.M' | wc -l\") do\n    its('stdout.strip') { should eq '0' }\n  end\n\nend\n" }

    let(:wrong_code) {
      "package recaster;

      import java.io.BufferedReader;
      import java.io.DataOutputStream;
      import java.io.IOException;
      import java.io.InputStreamReader;
      import java.net.HttpURLConnection;
      import java.net.URL;

      import org.json.simple.JSONObject;
      import org.json.simple.parser.JSONParser;
      import org.json.simple.parser.ParseException;

      public class HttpSyncManager implements SyncManager {
          String baseUrl;

          public HttpSyncManager(String baseUrl) {
              this.baseUrl = baseUrl;
          }
      }"
    }

    it 'get is_editable?' do
      expect(control.is_editable?).to eq true
    end

    it 'set refs_list' do
      control.refs_list='ref1, ref2'
      expect(control.refs).to eq %w{ref1 ref2}
    end

    it 'get short title' do
      expect(control.short_title).to eq 'The file permissions, ownership, and group membersh...'
    end

    it 'get low severity' do
      control.impact = 0.2
      expect(control.severity).to eq 'low'
    end

    it 'get medium severity' do
      control.impact = 0.5
      expect(control.severity).to eq 'medium'
    end

    it 'get high severity' do
      control.impact = 0.9
      expect(control.severity).to eq 'high'
    end

    it 'get build json string' do
      expect(control.to_json).to be_a(String)
      expect(JSON.parse(control.to_json)).to have_key('title')
    end

    it 'get build json' do
      expect(control.as_json).to have_key('title')
    end

    it 'parse bad code' do
      code = Control.parse bad_code
      expect(code).to eq nil
    end

    it "can't save bad code" do
      control.code = wrong_code
      expect(control.save).to eq false
    end
  end

  context 'Evaluation imported' do
    let(:eval) { Evaluation.parse(JSON.parse(File.open('spec/support/ngadev-test1.json', 'r').read)) }

    it 'get start time' do
      control = eval.profiles.first.controls.first
      expect(control.start_time).to eq '2018-04-08 19:24:40.000000000 +0000'
    end
  end
end
