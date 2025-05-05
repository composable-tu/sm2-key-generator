//
// Copyright (c) 2025 LuminaPJ
// SM2 Key Generator is licensed under Mulan PSL v2.
// You can use this software according to the terms and conditions of the Mulan PSL v2.
// You may obtain a copy of Mulan PSL v2 at:
//          http://license.coscl.org.cn/MulanPSL2
// THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
// EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
// MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
// See the Mulan PSL v2 for more details.
//

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../data/key_generator_state.dart';

class SM2KeyGeneratorHomePage extends StatelessWidget {
  const SM2KeyGeneratorHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<KeyGeneratorState>(context);

    return Scaffold(
      appBar: AppBar(title: Text(context.tr('app_name'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 8.0,
          bottom: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _KeyCard(title: context.tr('public_key'), value: state.publicKey),
            const SizedBox(height: 12),
            _KeyCard(title: context.tr('private_key'), value: state.privateKey),
            const SizedBox(height: 12),
            Row(
              children: [
                const SizedBox(width: 4),
                FilledButton.tonalIcon(
                  icon:
                      state.isLoading
                          ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              year2023: false,
                              strokeWidth: 2,
                            ),
                          )
                          : const SizedBox.shrink(),
                  onPressed: state.isLoading ? null : () => state.generateKeys(context),
                  label: Text(context.tr('generate')),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed:
                      (state.isLoading ||
                              state.publicKey == null ||
                              state.privateKey == null)
                          ? null
                          : () => _copyToClipboard(context, state),
                  child: Text(context.tr('copy')),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _InfoCard(),
          ],
        ),
      ),
    );
  }

  Future<void> _copyToClipboard(
    BuildContext context,
    KeyGeneratorState state,
  ) async {
    var publicKey = state.publicKey;
    var privateKey = state.privateKey;
    if (publicKey == null || privateKey == null) return;

    final text = 'publicKey: "$publicKey"\nprivateKey: "$privateKey"';
    await Clipboard.setData(ClipboardData(text: text));

    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.tr('copy_success'))));
  }
}

class _KeyCard extends StatelessWidget {
  final String title;
  final String? value;

  const _KeyCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              value == null
                  ? context.tr('gen_waiting')
                  : value == 'error'
                  ? context.tr('gen_error')
                  : value!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr('tips'),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.tr('tips_content'),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
