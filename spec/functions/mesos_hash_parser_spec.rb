#! /usr/bin/env ruby -S rspec
require 'spec_helper'
require 'rspec-puppet'

describe 'mesos_hash_parser' do

  describe 'convert key-value to a puppet resource hash' do
    it 'convert simple hash' do
      param = {
        'isolation' => 'cgroups',
      }

      subject.should run.with_params(param).and_return({
          'isolation' => {
            'value' => 'cgroups',
            'file' => 'isolation',                                                   
          }
        })
    end

    it 'should raise an error if run with extra arguments' do
      subject.should run.with_params(1, 2, 3, 4).and_raise_error(Puppet::ParseError)
    end
  end

  describe 'support prefixes' do
    it 'should prefix keys' do
      param = {
        'root' => '/cgroups',
      }

      subject.should run.with_params(param, 'cg').and_return({
          'cg_root' => {
            'value' => '/cgroups',
            'file' => 'root',                                                         
          }
        })
    end

    it 'should prefix files' do
      param = {
        'root' => '/cgroups',
      }

      subject.should run.with_params(param, 'cg', 'cg').and_return({
          'cg_root' => {
            'value' => '/cgroups',
            'file' => 'cg_root',
          }
        })
    end
  end

end
